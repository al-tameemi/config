{ config, lib, ... }:
{
  options.modules.mounts.enable = lib.mkEnableOption "bind mounts";

  config = lib.mkIf config.modules.mounts.enable {
    fileSystems."/home/${config.modules.username}/.config" = {
      device = "/config/home/.config";
      options = [ "bind" ];
      fsType = "None";
    };
  };
}
