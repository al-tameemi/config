{config, pkgs, lib, ... }:

{
  programs.dconf.enable = true;
  
  users.users.mohammed.extraGroups = [ "libvirtd" ];
  
  environment.systemPackages = with pkgs; lib.mkAfter [
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
  ];
  
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
      };
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
}
