{ config, pkgs, ... }:
{
  imports =
    [
      ./common_mounts.nix
      ./applications.nix
      ./user_packages.nix
      ./boot.nix
      ./virt.nix
    ];

  system.stateVersion = "24.11"; # Keep

  nix.optimise.automatic = true;

  # Enable networking
  networking.networkmanager.enable = true;
  networking.extraHosts =
  ''
    192.168.1.22 server altamemr01
    192.168.1.1 router
  '';
  # Set your time zone.
  time.timeZone = "America/Denver";

  # Select internationalisation
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  environment.sessionVariables = rec {
    SHELL = "${pkgs.fish}/bin/fish";
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
    NIXOS_OZONE_WL = "1";
  };

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  ###################### ENVIRONMENTS #############################
  # Enable the GNOME Desktop Environment.
  # services.displayManager.sddm = {
    # enable = true;
    # wayland.enable = true;
  # };
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.displayManager.defaultSession = "gnome";
  # Enable KDE desktop environment
  services.desktopManager.plasma6.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;
  # fix sshaskpass
  programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.kdePackages.ksshaskpass.out}/bin/ksshaskpass";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Sudo requires root password
  # security.sudo.extraConfig = "Defaults:%wheel rootpw\n";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.brlaser ];

  # Enable sound with pipewire.
  # sound.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

  };
  services.pulseaudio.zeroconf.discovery.enable = true;
  services.pulseaudio.zeroconf.publish.enable = true;
  
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
    ];
  };


  # default shell
  users.defaultUserShell = pkgs.fish;
  networking.firewall.enable = false;
}
