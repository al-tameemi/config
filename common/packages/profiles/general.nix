{ config, lib, ... }:
{
  options.modules.general.enable = lib.mkEnableOption "general profile";

  config = lib.mkIf config.modules.general.enable {
    programs = {
      command-not-found.enable = true;
      mtr.enable = true;
      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };
    };
  };
}
