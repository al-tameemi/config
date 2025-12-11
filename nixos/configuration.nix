{ config, pkgs, ... }:
{
	system.stateVersion = "24.11";
  boot.loader.systemd-boot.enable = lib.mkForce false;
	networking.hostName = "nixos";
	powerManagement.cpuFreqGovernor = "performance";
	services.udev.extraRules = ''
		ACTION=="add", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c547", ATTR{power/wakeup}="disabled"
	'';
	services.scx = {
		enable = true;
		scheduler = "scx_bpfland";
	};
	boot.kernelPackages = pkgs.linuxPackages_zen;
}
