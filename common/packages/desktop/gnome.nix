{ config, lib, pkgs, ... }:
{
  options.modules.gnome.enable = lib.mkEnableOption "GNOME packages";

  config = lib.mkIf config.modules.gnome.enable {
    users.users.${config.modules.username}.packages = with pkgs; [
      gnome-themes-extra
      gimp
      gnome-tweaks
      gnomeExtensions.dash-to-dock
      gnomeExtensions.blur-my-shell
      gnomeExtensions.appindicator
      gnomeExtensions.status-icons
      gnomeExtensions.clipboard-history
    ];
  };
}
