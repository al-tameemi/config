{ config, lib, pkgs, ... }:
{
  options.modules.dev.editors.gui.enable = lib.mkEnableOption "GUI editors";

  config = lib.mkIf config.modules.dev.editors.gui.enable {
    users.users.${config.modules.username}.packages = with pkgs; [
      jetbrains.rust-rover
      vscode
      # code-cursor
      zed-editor
    ];
  };
}
