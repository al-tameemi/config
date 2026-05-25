{ config, lib, pkgs, ... }:
{
  options.modules.wine.enable = lib.mkEnableOption "Wine (Windows compatibility layer)";

  config = lib.mkIf config.modules.wine.enable {
    users.users.${config.modules.username}.packages = with pkgs; [
      wineWow64Packages.waylandFull
      winetricks
    ];
  };
}
