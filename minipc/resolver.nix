{ config, pkgs, ... }:
{
  systemd.services.resolve = {
    description = "Resolve Service";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = "/resolve/resolver_server --index /resolve/crates.io-index --static /resolve/static";
      Restart = "on-failure";
      RestartSec = 5;

      User = "mohammed";
      Group = "users";
    };
  };
}
