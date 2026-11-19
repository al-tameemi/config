# The Valheim container itself is run via docker compose from ~/valheim-server
# (restart: always); this module provides docker and opens the ports.
{ config, lib, pkgs, ... }:
let
  cfg = config.modules.server.valheim;
in
{
  options.modules.server.valheim.enable = lib.mkEnableOption "Valheim (docker compose) host support";

  config = lib.mkIf cfg.enable {
    virtualisation.docker.enable = true;
    users.users.${config.modules.username}.extraGroups = [ "docker" ];
    environment.systemPackages = [ pkgs.docker-compose ];
    networking.firewall = {
      allowedUDPPortRanges = [ { from = 2456; to = 2458; } ];
      allowedTCPPorts = [ 9001 ];
    };
  };
}
