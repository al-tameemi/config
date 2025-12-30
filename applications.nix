# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  programs.java.enable = true;
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    zlib
    openssl
    openssl.dev
    curl
    glib
    glib.dev
    gtk4
    gtk4.dev
    pkg-config
    libgda6 
    gsound
    # steam-fhsenv-without-steam
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; 
    dedicatedServer.openFirewall = true; 
    package = pkgs.steam.override {
      extraPkgs = pkgs: with pkgs; [
        libkrb5
        keyutils
      ];
    };
  };
  # programs.hyprland = {
  #   enable = true;
  #   xwayland.enable = true;
  # };

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSOR = "1";
    NIXOS_OZONE_WL = "1";
  };

  hardware = {
    graphics.enable = true;
  };

  # fonts.packages = with pkgs; [
  #   jetbrains-mono
  # ];
      
  users.users.mohammed = {
    isNormalUser = true;
    description = "Mohammed Al-Tameemi";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    helix
    tpm2-tss
    kdiskmark
    btrfs-progs
    eza 
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    curl
    # home-manager
    gparted
    killall
    corectrl
    htop
    gamemode
    libiconv 
    wineWowPackages.waylandFull
    winetricks
    kdePackages.polkit-kde-agent-1
    polkit_gnome
    gnome-keyring
    brightnessctl
    ly
    cachix
    xwayland-satellite # For niri xwayland support
    zoxide
    gnome-themes-extra
    # scanmem
    inter
    terminus_font
    ripgrep
    sbctl
    niv
  ];

  services.flatpak.enable = true;
}
