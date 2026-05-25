{ config, lib, pkgs, ... }:
{
  options.modules.gnome.enable = lib.mkEnableOption "GNOME packages";

  config = lib.mkIf config.modules.gnome.enable {
    users.users.${config.modules.username}.packages = with pkgs; [
      gnome-themes-extra
      gimp
      gnome-tweaks
      gnomeExtensions.clipboard-indicator
      gnomeExtensions.dash-to-dock
      gnomeExtensions.pano
      gnomeExtensions.blur-my-shell
      gnomeExtensions.appindicator
      gnomeExtensions.status-icons
      gnomeExtensions.all-in-one-clipboard
      gnomeExtensions.clipboard-history
    ];
  };
}
