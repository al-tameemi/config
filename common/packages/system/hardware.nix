{ config, lib, pkgs, ... }:
{
  options.modules.hardware.enable = lib.mkEnableOption "hardware support packages";

  config = lib.mkIf config.modules.hardware.enable {
    users.users.${config.modules.username}.packages = with pkgs; [
      openrgb
      corectrl
      gparted
      kdiskmark
    ];
  };
}
