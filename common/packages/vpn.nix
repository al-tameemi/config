{ config, lib, pkgs, ... }:
{
  options.modules.vpn.enable = lib.mkEnableOption "vpn packages";

  config = lib.mkIf config.modules.vpn.enable {
    users.users.${config.modules.username}.packages = with pkgs; [
       wireguard-tools
       proton-vpn
    ];
  };
}
