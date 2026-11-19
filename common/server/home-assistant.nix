{ config, lib, ... }:
let
  cfg = config.modules.server.homeAssistant;
  us = cfg.unitSystem == "us_customary";
in
{
  options.modules.server.homeAssistant = {
    enable = lib.mkEnableOption "Home Assistant";
    port = lib.mkOption {
      type = lib.types.port;
      default = 8123;
    };
    unitSystem = lib.mkOption {
      type = lib.types.enum [ "metric" "us_customary" ];
      default = "us_customary";
    };
    extraComponents = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "default_config" "met" "esphome" "mqtt" "cast" "homekit" "isal" "radio_browser" ];
      description = "Integrations built into the package (nixpkgs home-assistant component names).";
    };
  };

  config = lib.mkIf cfg.enable {
    services.home-assistant = {
      enable = true;
      openFirewall = true;
      inherit (cfg) extraComponents;
      config = {
        default_config = { };
        homeassistant = {
          name = "Home";
          time_zone = config.time.timeZone;
          unit_system = cfg.unitSystem;
          temperature_unit = if us then "F" else "C";
        };
        http.server_port = cfg.port;
        # UI-managed; files must exist or HA refuses to start (see tmpfiles below).
        automation = "!include automations.yaml";
        scene = "!include scenes.yaml";
        script = "!include scripts.yaml";
      };
    };

    systemd.tmpfiles.rules = map
      (f: "f ${config.services.home-assistant.configDir}/${f}.yaml 0644 hass hass")
      [ "automations" "scenes" "scripts" ];

    services.avahi.enable = lib.mkDefault true; # device discovery
  };
}
