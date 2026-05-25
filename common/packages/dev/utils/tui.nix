{ config, lib, pkgs, ... }:
{
  options.modules.dev.utils.tui.enable = lib.mkEnableOption "TUI/CLI utilities";

  config = lib.mkIf config.modules.dev.utils.tui.enable {
    users.users.${config.modules.username}.packages = with pkgs; [
      devenv
      direnv
      curl
      claude-code
    ];
  };
}
