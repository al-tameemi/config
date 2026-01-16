{ config, pkgs, ... }:
{
  boot.loader.systemd-boot.enable = lib.mkForce false;
	system.stateVersion = "24.11";
	powerManagement.cpuFreqGovernor = "performance";
	services.udev.extraRules = ''
		ACTION=="add", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c547", ATTR{power/wakeup}="disabled"
	'';
	services.scx = {
		enable = true;
		scheduler = "scx_bpfland";
	};
	boot.kernelPackages = pkgs.linuxPackages_zen;

	networking = {
		hostName = "nixos";
		interfaces = {
			ens3 = {
				wakeOnLan.enable = true;
			};
		};
		firewall = {
			allowedUDPPorts = [ 9 ];
		};
	};
}
