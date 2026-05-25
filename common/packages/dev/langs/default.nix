{ config, lib, pkgs, ... }:
{
  options.modules.dev.langs.enable = lib.mkEnableOption "development languages";

  config = lib.mkIf config.modules.dev.langs.enable {
    users.users.${config.modules.username}.packages = with pkgs; [
      python3
      rustup
      lldb
      # haskellPackages.ghcup
    ];
  };
}
