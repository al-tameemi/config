{ config, pkgs, inputs, ... }:
{
  imports =
    [
      ./common/mounts.nix
      ./common/programs.nix
      ./common/packages.nix
      ./common/boot.nix
      ./common/virt.nix
      ./common/services.nix
    ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix = {
    settings = {
      trusted-users = [ "root" "mohammed" ];
      experimental-features = [ "nix-command" "flakes" ];
      download-buffer-size = 524288000; # 500 mib
    };
    optimise.automatic = true;
  };


  # Enable networking
  networking = {
    
  networkmanager = {
    enable = true;
    plugins = with pkgs; [
      networkmanager-openvpn
    ];
  };
  extraHosts =
    ''
      192.168.1.22 server altamemr01
      192.168.1.1 router
    '';
  };  
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
    SHELL = "${pkgs.nushell}/bin/nu";
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
    PROTON_FSR4_UPGRADE = "1";
    PROTON_FSR4_INDICATOR = "1";
    WLR_NO_HARDWARE_CURSOR = "1";
    NIXOS_OZONE_WL = "1";
  };
  
  hardware = {
    graphics.enable = true;
  };
  
  xdg.portal = {
    enable = true;
    # enabled by niri
    # wlr.enable = true;
    extraPortals = with pkgs; [
      # xdg-desktop-portal-hyprland
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

  users = {
    users.mohammed = {
      isNormalUser = true;
      description = "Mohammed Al-Tameemi";
      extraGroups = [ "networkmanager" "wheel" ];
    };
    defaultUserShell = pkgs.nushell;
  };

  networking.firewall.enable = false;

  systemd.services."prepare-kexec".wantedBy = [ "multi-user.target" ];
}
