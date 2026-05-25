{ config, lib, pkgs, ... }:
{
  options.modules.dev.virt.enable = lib.mkEnableOption "virtualization tools";

  config = lib.mkIf config.modules.dev.virt.enable {
    users.users.${config.modules.username}.packages = with pkgs; [
      gnome-boxes
      podman-desktop
    ];
  };
}
