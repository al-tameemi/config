{ config, pkgs, ... }:

{
  services.home-assistant = {
    enable = true;
    openFirewall = true; # TCP 8123

    # Integrations whose Python deps get built into the package.
    # Add more here as needed (names from the nixpkgs home-assistant component list).
    extraComponents = [
      "default_config"
      "met"
      "esphome"
      "mqtt"
      "cast"
      "homekit"
      "isal"
      "radio_browser"
    ];

    config = {
      default_config = { };
      homeassistant = {
        name = "Home";
        time_zone = config.time.timeZone;
        unit_system = "us_customary";
        temperature_unit = "F";
      };
      http = {
        server_port = 8123;
        # Uncomment if you later put this behind the nginx reverse proxy:
        # use_x_forwarded_for = true;
        # trusted_proxies = [ "127.0.0.1" "::1" ];
      };
      # Let the UI manage these instead of YAML.
      automation = "!include automations.yaml";
      scene = "!include scenes.yaml";
      script = "!include scripts.yaml";
    };
  };

  # The files referenced by !include must exist or HA refuses to start.
  systemd.tmpfiles.rules = [
    "f ${config.services.home-assistant.configDir}/automations.yaml 0644 hass hass"
    "f ${config.services.home-assistant.configDir}/scenes.yaml 0644 hass hass"
    "f ${config.services.home-assistant.configDir}/scripts.yaml 0644 hass hass"
  ];

  # mDNS discovery (Chromecast, HomeKit, etc.)
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
