{ config, lib, pkgs, ... }:
{
  options.modules.fonts.enable = lib.mkEnableOption "fonts";

  config = lib.mkIf config.modules.fonts.enable {
    users.users.${config.modules.username}.packages = with pkgs; [
      jetbrains-mono
      papirus-icon-theme
      font-awesome
      source-han-sans
      source-han-serif
    ];

    fonts.packages = with pkgs; [
      inter
      terminus_font
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      mplus-outline-fonts.githubRelease
      dina-font
      proggyfonts
      jetbrains-mono
      papirus-icon-theme
      font-awesome
      source-han-sans
      source-han-serif
    ];
  };
}
