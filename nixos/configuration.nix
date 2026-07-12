{ config, pkgs, lib, ... }:
{
	imports = [
		./hardware-configuration.nix
		./mounts.nix
	];
  modules.username = "mohammed";
  modules.boot.silent = true;
  modules.desktop.enable = true;
  modules.desktop.dev.enable = true;
  modules.services.desktop.enable = true;
  modules.virt.gui.enable = true;
	system.stateVersion = "24.11";

	nix.settings = {
		substituters = [
			"https://nix-community.cachix.org"
		];
		trusted-public-keys = [
			"nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
		];
	};

	boot = {
	  loader.systemd-boot.enable = lib.mkForce false;
	  kernelParams = [ "amdgpu.gpu_recovery=1" ];
		kernelPackages = pkgs.linuxPackages_zen;
	};

	powerManagement.cpuFreqGovernor = "performance";

	environment.systemPackages = with pkgs; [
	  rocmPackages.rocminfo
	  rocmPackages.rocm-smi
	  rocmPackages.amdsmi
	  uv
	];

	# zram first: fast, compressed, in RAM
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 25;   # caps the device at ~8 GB uncompressed on your 32 GB
    priority = 100;
  };

  # disk swap on the unencrypted NVMe as overflow, used only after zram fills
  swapDevices = [
    {
      device = "/drives/NVME2/swapfile";
      size = 32 * 1024;   # MiB
      priority = 10;
    }
  ];

  # no swap readahead; it's tuned for spinning disks and wastes work on zram/NVMe
  boot.kernel.sysctl."vm.page-cluster" = 0;

	users.users.mohammed.extraGroups = [ "video" "render" ];
  
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
