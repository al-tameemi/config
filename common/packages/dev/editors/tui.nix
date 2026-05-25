{ config, lib, pkgs, ... }:
{
  options.modules.dev.editors.tui.enable = lib.mkEnableOption "TUI editors";

  config = lib.mkIf config.modules.dev.editors.tui.enable {
    users.users.${config.modules.username}.packages = with pkgs; [
      neovim
    ];
  };
}
