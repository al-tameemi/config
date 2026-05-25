{ config, lib, pkgs, ... }:
{
  options.modules.cli-utils.enable = lib.mkEnableOption "CLI utilities";

  config = lib.mkIf config.modules.cli-utils.enable {
    users.users.${config.modules.username}.packages = with pkgs; [
      socat
      jq
      eza
      zellij
      wget
      htop
      ripgrep
      zoxide
      cachix
      niv
    ];
  };
}
