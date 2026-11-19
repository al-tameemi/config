{ config, lib, ... }:
let
  cfg = config.modules.server.resolver;
in
{
  options.modules.server.resolver = {
    enable = lib.mkEnableOption "resolver service";
    dir = lib.mkOption {
      type = lib.types.str;
      default = "/resolve";
      description = "Contains resolver_server, crates.io-index and static/.";
    };
    port = lib.mkOption {
      type = lib.types.port;
      default = 3000;
      description = "Port the server listens on (used as the proxy backend).";
    };
    domain = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "If set, proxy this domain to the service via modules.server.reverseProxy.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.resolve = {
      description = "Resolve Service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${cfg.dir}/resolver_server --index ${cfg.dir}/crates.io-index --static ${cfg.dir}/static";
        Restart = "on-failure";
        RestartSec = 5;
        User = config.modules.username;
        Group = "users";
      };
    };

    modules.server.reverseProxy.hosts = lib.mkIf (cfg.domain != null) {
      ${cfg.domain}.port = cfg.port;
    };
  };
}
