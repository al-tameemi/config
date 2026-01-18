{ config, pkgs, lib, ... }:

{

  boot = {
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
      "preempt=full"
    ];
    loader.timeout = 0;
  };
}
