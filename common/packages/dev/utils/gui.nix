{ config, lib, pkgs, ... }:
{
  options.modules.dev.utils.gui.enable = lib.mkEnableOption "GUI utilities";

  config = lib.mkIf config.modules.dev.utils.gui.enable {
    users.users.${config.modules.username}.packages = with pkgs; [
      alacritty
      wezterm
    ];
  };
}
