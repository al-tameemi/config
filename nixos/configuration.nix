{ config, pkgs, lib, ... }:
{
	imports = [
		./hardware-configuration.nix
		./mounts.nix
	];
	system.stateVersion = "24.11";

	boot = {
	  loader.systemd-boot.enable = lib.mkForce false;
		kernelPackages = pkgs.linuxPackages_zen;
	};

	powerManagement.cpuFreqGovernor = "performance";

	services = {
		udev.extraRules = ''
			ACTION=="add", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c547", ATTR{power/wakeup}="disabled"
		'';
		scx = {
			enable = true;
			scheduler = "scx_bpfland";
		};
	};

	networking = {
		hostName = "nixos";
		interfaces = {
			eno1 = {
				wakeOnLan.enable = true;
			};
		};
		firewall = {
			allowedUDPPorts = [ 9 ];
		};
	};
}
