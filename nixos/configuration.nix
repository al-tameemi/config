{ config, pkgs, ... }:
{
	system.stateVersion = "24.11";
	networking.hostName = "nixos";
	powerManagement.cpuFreqGovernor = "performance";
	services.udev.extraRules = ''
		ACTION=="add", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c547", ATTR{power/wakeup}="disabled"
	'';
	services.scx = {
		enable = true;
		scheduler = "scx_flash";
		extraArgs = [
			"-m"  "all"
		];
	};
	boot.kernelPackages = pkgs.linuxPackages_zen;
}
