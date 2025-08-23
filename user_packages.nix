{ config, pkgs, fetchzip, ...}:
let
  baseconfig = { allowUnfree = true; };
  small-unstable = import <nixos-unstable-small> { config = baseconfig; };

  vscode-insiders = (pkgs.vscode.override { isInsiders = true; }).overrideAttrs (oldAttrs: rec {
    src = (builtins.fetchTarball {
      url = "https://code.visualstudio.com/sha/download?build=insider&os=linux-x64";
      sha256 = "01ln0dv9f3dpvh9q2jplmjv8ldidpxgycl0k5nnrdkkzn28r60y2";
    });
    version = "latest";

    buildInputs = oldAttrs.buildInputs ++ [ pkgs.krb5 ];
  });


  fontInstalls = with pkgs; [
    jetbrains-mono
    papirus-icon-theme
    # nerdfonts
    font-awesome
    source-han-sans
    source-han-serif
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
    # protonplus
    # protonup-qt
  ];

  devInstalls = with pkgs; [
    jujutsu
    python3
    rustup
    # Currently broken, change later
    # haskellPackages.ghcup
    # jetbrains.rust-rover
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
    #code-cursor
    zed-editor
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
    fuzzel
    # swaylock
    swaylock-effects
    swww
    swayidle
    nushell
    floorp
    zathura
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
    # vesktop
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
