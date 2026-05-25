{ config, lib, pkgs, ... }:
{
  options.modules.system.enable = lib.mkEnableOption "system packages";

  config = lib.mkIf config.modules.system.enable {
    environment.systemPackages = with pkgs; [
      curl
      tpm2-tss
      btrfs-progs
      sbctl
      helix
      nushell
    ];
  };
}
