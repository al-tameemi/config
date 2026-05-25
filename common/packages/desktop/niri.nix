{ config, lib, pkgs, ... }:
{
  options.modules.niri.enable = lib.mkEnableOption "Niri compositor";

  config = lib.mkIf config.modules.niri.enable {
    modules.wm-support.enable = true;
    programs.niri.enable = true;

    environment.systemPackages = with pkgs; [
      xwayland-satellite
    ];
  };
}
