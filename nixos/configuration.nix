{ config, pkgs, ... }:
{
	system.stateVersion = "24.11";
	networking.hostName = "nixos";
	powerManagement.cpuFreqGovernor = "performance";
	services.udev.extraRules = ''
		ACTION=="add", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c547", ATTR{power/wakeup}="disabled"
	'';

  boot.kernelPackages = pkgs.linuxPackages_zen;
}
