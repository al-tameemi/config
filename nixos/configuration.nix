{ config, pkgs, ... }:
{
	system.stateVersion = "24.11";

	powerManagement.cpuFreqGovernor = "performance";
	services.udev.extraRules = ''
		ACTION=="add", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c547", ATTR{power/wakeup}="disabled"
	'';

  boot.kernelPackages = pkgs.linuxPackages_cachyos;
}
