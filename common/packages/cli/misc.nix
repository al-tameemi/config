{ config, lib, pkgs, ... }:
{
  options.modules.misc.enable = lib.mkEnableOption "miscellaneous packages";

  config = lib.mkIf config.modules.misc.enable {
    users.users.${config.modules.username}.packages = with pkgs; [
      dix
      fastfetch
      neo-cowsay
      fortune-kind
    ];
  };
}
