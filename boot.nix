{ config, pkgs, lib, ... }:

{

  boot = {
    loader.systemd-boot.enable = lib.mkForce false;
    loader.efi.canTouchEfiVariables = true;

    supportedFilesystems = [ "ntfs" ];
    initrd.systemd.enable = true;
    consoleLogLevel = 0;
    initrd.verbose = false;
    plymouth.theme = "bgrt";
    kernelParams = [
      "splash"
      "quiet"
      "loglevel=3"
      "boot.shell_on_fail"
    ];
    loader.timeout = 0;
  };
  # services.scx.enable = true; # by default uses scx_rustland scheduler
}
