{ config, pkgs, fetchzip, ...}:
let
  baseconfig = { allowUnfree = true; };
  small-unstable = import <nixos-unstable-small> { config = baseconfig; };
  fontInstalls = with pkgs; [
    jetbrains-mono
    papirus-icon-theme
    # nerdfonts
    font-awesome
  ];

  # kde-catppuccin = pkgs.catppuccin-kde.override {
  #   flavour = ["mocha" "macchiato"];
  #   accents = ["yellow" "peach"];
  # };

  gnomeInstalls = with pkgs; [
    gimp
    gnome-tweaks
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.dash-to-dock
    gnomeExtensions.pano # Currently borked on gnome 46
    gnomeExtensions.blur-my-shell
    gnomeExtensions.appindicator
  ];

  gamingInstalls = with pkgs; [
    discord
    mangohud
    gamescope
    bottles
    heroic
    lutris
  ];

  devInstalls = with pkgs; [
    python3
    jetbrains.rust-rover
    helix
    gnome-boxes
    neovim
    curl
    alacritty
    kitty
    ghostty
    wezterm
    git
    vscode
  ];

  hyprlandInstalls = with pkgs; [
    rofi-wayland
    wl-clipboard
    cliphist
    waybar
    hyprpaper
    hyprshot
    hypridle
    hyprlock
    hyprcursor
    mako
  ];

  miscInstalls = with pkgs; [
    fish
    nushell
    firefox-beta
    ffmpeg
    # blender # currently broken :)
    fastfetch
    neo-cowsay
    fortune-kind
    guvcview
    # cider
    protonvpn-gui
    pavucontrol
    # xwaylandvideobridge
    vesktop
    socat
    jq
    libreoffice
    eza
    signal-desktop
    easyeffects
    zellij
  ];
in
{
  users.users.mohammed.packages = fontInstalls ++ gnomeInstalls ++ gamingInstalls ++ miscInstalls ++ devInstalls ++ hyprlandInstalls;
  # users.users.mohammed.shell = pkgs.nushell;
}
