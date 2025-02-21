# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./common_mounts.nix
      ./mounts.nix
      ./applications.nix
      ./user_packages.nix
      ./boot.nix
      ./virt.nix
    ];

  networking.hostName = "nixos"; # Define your hostname.
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

  # imports = [
  #   ./applications.nix
  #   ./user_packages.nix
  #   ./boot.nix
  #   ./virt.nix
  #   #./gdm.nix
  # ];
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
      # xdg-desktop-portal-gtk
    ];
  };

  powerManagement.cpuFreqGovernor = "performance";

  # default shell
  users.defaultUserShell = pkgs.fish;
  networking.firewall.enable = false;
  services.udev.extraRules = ''
    ACTION=="add", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c547", ATTR{power/wakeup}="disabled"
  '';
}
