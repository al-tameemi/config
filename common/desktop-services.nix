{ config, lib, pkgs, ... }:
{
  options.modules.services.desktop.enable = lib.mkEnableOption "desktop services";

  config = lib.mkIf config.modules.services.desktop.enable {
    services = {
      hardware.openrgb.enable = true;

      xserver = {
        enable = true;
        displayManager.sessionCommands = ''
          eval $(gnome-keyring-daemon --start --daemonize --components=ssh,secrets)
          export SSH_AUTH_SOCK
        '';
        xkb = {
          layout = "us";
          variant = "";
        };
      };

      displayManager = {
        gdm.enable = true;
        defaultSession = "gnome";
      };

      desktopManager = {
        gnome.enable = true;
        cosmic.enable = true;
        plasma6.enable = true;
      };

      printing = {
        enable = true;
        drivers = [ pkgs.brlaser pkgs.brgenml1lpr pkgs.brgenml1cupswrapper  ];
      };

      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };

      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
      };

      pulseaudio.enable = false;

      dbus.packages = [ pkgs.gnome-keyring pkgs.gcr ];

      flatpak.enable = true;
    };
  };
}
