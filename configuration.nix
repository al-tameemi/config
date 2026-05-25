{ config, pkgs, inputs, ... }:
{
  imports = [
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
      trusted-users = [ "root" config.modules.username ];
      experimental-features = [ "nix-command" "flakes" ];
      download-buffer-size = 524288000; # 500 mib
    };
    optimise.automatic = true;
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
    firewall.enable = false;
  };

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
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
