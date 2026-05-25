{ config, lib, pkgs, ... }:
{
  options.modules.documents.enable = lib.mkEnableOption "document viewer and office packages";

  config = lib.mkIf config.modules.documents.enable {
    users.users.${config.modules.username}.packages = with pkgs; [
      foliate
      zathura
      libreoffice
    ];
  };
}
