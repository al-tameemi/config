{ config, lib, pkgs, ... }:
let
  cfg = config.modules.virt;
in
{
  options.modules.virt = {
    enable = lib.mkEnableOption "virtualisation";
    gui.enable = lib.mkEnableOption "virtualisation GUI tools";
  };

  config = lib.mkIf cfg.enable {
    programs.dconf.enable = true;

    users.users.${config.modules.username}.extraGroups = [ "libvirtd" ];

    environment.systemPackages = with pkgs; lib.mkAfter (
      lib.optionals cfg.gui.enable [
        virt-manager
        virt-viewer
        spice
        spice-gtk
        spice-protocol
        virtio-win
        win-spice
        adwaita-icon-theme
        dive
        podman-tui
        docker-compose
      ]
    );

    virtualisation = {
      libvirtd = {
        enable = true;
        qemu.swtpm.enable = true;
      };
      spiceUSBRedirection.enable = true;
      containers.enable = true;
      podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };
    };

    services.spice-vdagentd.enable = true;
  };
}
