{ config, lib, ... }:
let
  cfg = config.modules.server.reverseProxy;
in
{
  options.modules.server.reverseProxy = {
    enable = lib.mkEnableOption "nginx reverse proxy";
    certDir = lib.mkOption {
      type = lib.types.str;
      default = "/etc/ssl/cloudflare";
      description = "Directory holding cert.pem and key.pem (e.g. Cloudflare origin cert).";
    };
    hosts = lib.mkOption {
      default = { };
      description = "Domain -> local backend.";
      type = lib.types.attrsOf (lib.types.submodule ({ name, ... }: {
        options = {
          port = lib.mkOption { type = lib.types.port; };
          websockets = lib.mkOption { type = lib.types.bool; default = true; };
          tls = lib.mkOption { type = lib.types.bool; default = true; };
          certFile = lib.mkOption { type = lib.types.str; default = "${cfg.certDir}/cert.pem"; };
          keyFile = lib.mkOption { type = lib.types.str; default = "${cfg.certDir}/key.pem"; };
        };
      }));
    };
  };

  config = lib.mkIf cfg.enable {
    services.nginx = {
      enable = true;
      virtualHosts = lib.mapAttrs (_: h: {
        forceSSL = h.tls;
        sslCertificate = lib.mkIf h.tls h.certFile;
        sslCertificateKey = lib.mkIf h.tls h.keyFile;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString h.port}";
          proxyWebsockets = h.websockets;
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
          '';
        };
      }) cfg.hosts;
    };
    networking.firewall.allowedTCPPorts = [ 80 443 ];
  };
}
