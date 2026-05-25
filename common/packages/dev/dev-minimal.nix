{ config, lib, pkgs, ... }:
{
  options.modules.dev.minimal.enable = lib.mkEnableOption "minimal dev tools";

  config = lib.mkIf config.modules.dev.minimal.enable {
    users.users.${config.modules.username}.packages = with pkgs; [
      helix
      git
      jujutsu
    ];
  };
}
