{ config, pkgs, fetchzip, inputs, ...}:
let
  small-unstable = import <nixos-unstable-small> { config = { allowUnfree = true; }; };

  mpv-full = (pkgs.mpv-unwrapped.override { ffmpeg = pkgs.ffmpeg-full; });
  
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
    gnomeExtensions.status-icons
    gnomeExtensions.all-in-one-clipboard
    gnomeExtensions.clipboard-history
  ];

  gamingInstalls = with pkgs; [
    discord
    mangohud
    gamescope
    bottles
    heroic
    lutris
    r2modman
    # protonplus
    # protonup-qt
  ];

  devInstalls = with pkgs; [
    jujutsu
    python3
    rustup
    devenv
    direnv
    lldb
    claude-code
    lldb
    # Currently broken, change later
    # haskellPackages.ghcup
    jetbrains.rust-rover
    helix
    gnome-boxes
    neovim
    curl
    alacritty
    wezterm
    git
    vscode
    #code-cursor
    zed-editor
    podman-desktop
  ];

  hyprlandInstalls = with pkgs; [
    rofi
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
    openrgb
    fuzzel
    firefox
    foliate
    ungoogled-chromium
    # swaylock
    swaylock-effects
    swww
    swayidle
    quickshell
    nushell
    # floorp-bin
    zathura
    ffmpeg
    # blender # currently broken :)
    fastfetch
    neo-cowsay
    fortune-kind
    # cider
    # protonvpn-gui # Broken waiting on 461528
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
    mpv-full
    # Video/Audio data composition framework tools like "gst-inspect", "gst-launch" ...
    gst_all_1.gstreamer
    # Common plugins like "filesrc" to combine within e.g. gst-launch
    gst_all_1.gst-plugins-base
    # Specialized plugins separated by quality
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    # Plugins to reuse ffmpeg to play almost every video format
    gst_all_1.gst-libav
    # Support the Video Audio (Hardware) Acceleration API
    gst_all_1.gst-vaapi
  ];
in
{
  # User applications
  users.users.mohammed.packages = fontInstalls ++
                                  gnomeInstalls ++
                                  gamingInstalls ++
                                  miscInstalls ++
                                  devInstalls ++
                                  hyprlandInstalls;

  # System wide applications
  environment.systemPackages = with pkgs; [
    helix
    tpm2-tss
    kdiskmark
    btrfs-progs
    eza 
    vim
    wget
    curl
    gparted
    killall
    corectrl
    htop
    gamemode
    libiconv 
    wineWow64Packages.waylandFull
    winetricks
    kdePackages.polkit-kde-agent-1
    polkit_gnome
    gnome-keyring
    brightnessctl
    ly
    cachix
    xwayland-satellite # For niri xwayland support
    dms-shell
    dgop
    zoxide
    gnome-themes-extra
    inter
    terminus_font
    ripgrep
    sbctl
    niv
  ];  
}
