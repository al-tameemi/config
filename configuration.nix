{ config, pkgs, inputs, ... }:
{
  imports = [
    ./common/locale.nix
    ./common/nix.nix
    ./common/mounts.nix
    ./common/packages
    ./common/boot.nix
    ./common/virt.nix
    ./common/services.nix
    ./common/desktop-services.nix
    ./common/desktop.nix
  ];

  modules.general.enable = true;
  modules.boot.enable = true;
  modules.mounts.enable = true;
  modules.services.enable = true;
  modules.virt.enable = true;

  nixpkgs.config.allowUnfree = true;

  nix = {
    settings = {
      download-buffer-size = 524288000; # 500 mib
    };
  };

  networking = {
    networkmanager = {
      enable = true;
      plugins = with pkgs; [ networkmanager-openvpn ];
    };
    extraHosts = ''
      192.168.1.22 server altamemr01
      192.168.1.1 router
    '';
    firewall = {
      enable = true;
      checkReversePath = false;
    };
  };

  environment = {
    shells = [ pkgs.nushell ];
    sessionVariables.SHELL = "${pkgs.nushell}/bin/nu";
  };

  users = {
    users.${config.modules.username} = {
      isNormalUser = true;
      description = "Mohammed Al-Tameemi";
      extraGroups = [ "networkmanager" "wheel" ];
    };
    defaultUserShell = pkgs.nushell;
  };

  systemd.services."prepare-kexec".wantedBy = [ "multi-user.target" ];
}
