{ ... }:
{
  imports = [
    ./options.nix

    # Profiles
    ./profiles/general.nix
    ./profiles/desktop.nix

    # Desktop / WM
    ./desktop/gnome.nix
    ./desktop/hyprland.nix
    ./desktop/niri.nix
    ./desktop/wm-support.nix

    # System
    ./system/fonts.nix
    ./system/hardware.nix
    ./system/system.nix

    # CLI
    ./cli/cli-utils.nix
    ./cli/misc.nix

    # Apps
    ./browsers.nix
    ./documents.nix
    ./gaming.nix
    ./media.nix
    ./social.nix
    ./wine.nix

    # Dev
    ./dev/dev.nix
  ];
}
