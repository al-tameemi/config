{ config, lib, pkgs, ... }:
let
  cfg = config.modules.server;
in
{
  options.modules.server = {
    enable = lib.mkEnableOption "headless server defaults";
    timeZone = lib.mkOption {
      type = lib.types.str;
      default = "America/Denver";
      description = "System time zone (also used by Home Assistant).";
    };
  };

  config = lib.mkIf cfg.enable {
    boot.loader.systemd-boot.enable = lib.mkDefault true;
    boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;
    boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_zen;
    powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

    networking.networkmanager.enable = true;
    time.timeZone = cfg.timeZone;

    # Never sleep.
    systemd.targets = {
      sleep.enable = false;
      suspend.enable = false;
      hibernate.enable = false;
      hybrid-sleep.enable = false;
    };

    services.openssh.enable = true;

    # Publish <hostname>.local so the box is reachable without knowing its IP.
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
      publish = {
        enable = true;
        addresses = true;
      };
    };

    users.users.${config.modules.username} = {
      isNormalUser = true;
      extraGroups = [ "networkmanager" "wheel" ];
    };

    environment.systemPackages = with pkgs; [ helix wget curl htop git fish ];
  };
}
