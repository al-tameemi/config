
{ config, pkgs, ... }:
{
	networking.hostName = "framework";
	system.stateVersion = "24.11";
  boot.initrd.luks.devices."luks-cf287307-5394-4eb1-8973-4d7067d08036".device = "/dev/disk/by-uuid/cf287307-5394-4eb1-8973-4d7067d08036";
	services.fprintd.enable = true;
	security.pam.services.swaylock.fprintAuth = false;
  boot.kernelPackages = pkgs.linuxPackages_zen;
	boot.plymouth.enable = true;
}
