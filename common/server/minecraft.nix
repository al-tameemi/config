{ config, lib, ... }:
let
  cfg = config.modules.server.minecraft;
in
{
  options.modules.server.minecraft = {
    enable = lib.mkEnableOption "Minecraft server";
    port = lib.mkOption { type = lib.types.port; default = 43000; };
    memoryMB = lib.mkOption { type = lib.types.int; default = 2048; };
    maxPlayers = lib.mkOption { type = lib.types.int; default = 5; };
    motd = lib.mkOption { type = lib.types.str; default = "NixOS Minecraft server!"; };
    whitelist = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = "Username -> UUID.";
    };
    extraProperties = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Merged over the default server.properties.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.minecraft-server = {
      enable = true;
      eula = true;
      openFirewall = true;
      declarative = true;
      inherit (cfg) whitelist;
      serverProperties = {
        server-port = cfg.port;
        difficulty = 3;
        gamemode = "survival";
        max-players = cfg.maxPlayers;
        motd = cfg.motd;
        white-list = true;
        allow-cheats = true;
      } // cfg.extraProperties;
      jvmOpts = "-Xms${toString cfg.memoryMB}M -Xmx${toString cfg.memoryMB}M -Djava.net.preferIPv4Stack=true";
    };
  };
}
