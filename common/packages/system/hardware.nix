{ config, lib, pkgs, ... }:
{
  options.modules.hardware.enable = lib.mkEnableOption "hardware support packages";

  config = lib.mkIf config.modules.hardware.enable {
    programs.corectrl = {
      enable = true;
    };
    hardware.amdgpu.overdrive.enable = true;
    users.users.${config.modules.username} = {
      extraGroups = [ "corectrl" ];
      packages = with pkgs; [
        openrgb
        gparted
        kdiskmark
      ];
    };
  };
}
