{ config, lib, pkgs, ... }:
{
  config = lib.mkIf config.modules.desktop.enable {
    hardware.graphics.enable = true;

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gnome
        xdg-desktop-portal-gtk
      ];
    };

    security = {
      rtkit.enable = true;
      pam.services = {
        greetd.enableGnomeKeyring = true;
        greetd-password.enableGnomeKeyring = true;
        login.enableGnomeKeyring = true;
      };
    };

    environment.sessionVariables = {
      PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
      PROTON_FSR4_UPGRADE = "1";
      PROTON_FSR4_INDICATOR = "1";
      WLR_NO_HARDWARE_CURSOR = "1";
      NIXOS_OZONE_WL = "1";
      KWIN_TRIPLE_BUFFER = "1";
    };
  };
}
