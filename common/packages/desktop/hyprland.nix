{ config, lib, pkgs, ... }:
{
  options.modules.hyprland.enable = lib.mkEnableOption "Hyprland packages";

  config = lib.mkIf config.modules.hyprland.enable {
    modules.wm-support.enable = true;

    users.users.${config.modules.username}.packages = with pkgs; [
      hyprpaper
      hyprshot
      hypridle
      hyprlock
      hyprcursor
    ];
  };
}
