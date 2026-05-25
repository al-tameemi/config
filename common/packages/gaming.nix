{ config, lib, pkgs, ... }:
let
  cfg = config.modules.gaming;
in
{
  options.modules.gaming = {
    enable = lib.mkEnableOption "gaming packages";

    extra-launchers.enable = lib.mkEnableOption "extra game launchers (lutris, bottles, heroic)";
    proton-extra.enable = lib.mkEnableOption "extra Proton tools (protonplus, protonup-qt)";
    modding.enable = lib.mkEnableOption "game modding tools (r2modman)";
  };

  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      package = pkgs.steam.override {
        extraPkgs = pkgs: with pkgs; [
          libkrb5
          keyutils
        ];
      };
    };

    users.users.${config.modules.username}.packages = with pkgs; [
      discord
      mangohud
      gamescope
      gamemode
    ]
    ++ lib.optionals cfg.extra-launchers.enable [ lutris bottles heroic ]
    ++ lib.optionals cfg.proton-extra.enable [ protonplus protonup-qt ]
    ++ lib.optionals cfg.modding.enable [ r2modman ];
  };
}
