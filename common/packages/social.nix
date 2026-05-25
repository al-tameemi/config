{ config, lib, pkgs, ... }:
{
  options.modules.social.enable = lib.mkEnableOption "social and messaging packages";

  config = lib.mkIf config.modules.social.enable {
    users.users.${config.modules.username}.packages = with pkgs; [
      signal-desktop
    ];
  };
}
