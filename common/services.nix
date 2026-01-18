{ config, pkgs, inputs, ... }: {
  services = {
    automatic-timezoned.enable = true;
    # Enable the X11 windowing system.
    xserver = {
      enable = true;
      
      displayManager.sessionCommands = ''
            eval $(gnome-keyring-daemon --start --daemonize --components=ssh,secrets)
            export SSH_AUTH_SOCK
          '';
    };

    displayManager = {
      cosmic-greeter.enable = true;
      defaultSession = "gnome";
    };

    desktopManager = {
      gnome.enable = true;
      cosmic.enable = true;
      plasma6.enable = true;
    };

    # Configure keymap in X11
    xserver.xkb = {
      layout = "us";
      variant = "";
    };

    printing = {
      enable = true;
      drivers = [ pkgs.brlaser ];
    };

    pulseaudio = {
      enable = false;
      zeroconf = {
        discovery.enable = true;
        publish.enable = true;
      };
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;

    };
  
    # Enable the OpenSSH daemon.
    openssh.enable = true;

    dbus.packages = [ pkgs.gnome-keyring pkgs.gcr ];

    flatpak.enable = true;
  };
}
