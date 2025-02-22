
{ config, pkgs, ... }:
{
	system.stateVersion = "24.11";
  boot.initrd.luks.devices."luks-cf287307-5394-4eb1-8973-4d7067d08036".device = "/dev/disk/by-uuid/cf287307-5394-4eb1-8973-4d7067d08036";
	
  boot.kernelPackages = pkgs.linuxPackages_zen;
}
