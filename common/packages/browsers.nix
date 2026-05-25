{ config, lib, pkgs, ... }:
{
  options.modules.browsers.enable = lib.mkEnableOption "browser packages";

  config = lib.mkIf config.modules.browsers.enable {
    users.users.${config.modules.username}.packages = with pkgs; [
      firefox
      ungoogled-chromium
    ];
  };
}
