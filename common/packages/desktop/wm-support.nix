{ config, lib, pkgs, ... }:
{
  options.modules.wm-support.enable = lib.mkEnableOption "common WM/compositor support packages";

  config = lib.mkIf config.modules.wm-support.enable {
    environment.systemPackages = with pkgs; [
      kdePackages.polkit-kde-agent-1
      polkit_gnome
      gnome-keyring
      brightnessctl
      ly
    ];

    users.users.${config.modules.username}.packages = with pkgs; [
      rofi
      wl-clipboard
      cliphist
      waybar
      mako
      fuzzel
      awww
      swayidle
      # swaylock
      swaylock-effects
      quickshell
    ];
  };
}
