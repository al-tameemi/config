{ config, lib, ... }:
{
  options.modules.services.enable = lib.mkEnableOption "base services";

  config = lib.mkIf config.modules.services.enable {
    services = {
      automatic-timezoned.enable = true;
      openssh.enable = true;
    };
  };
}
