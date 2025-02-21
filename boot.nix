{ config, pkgs, ... }:

{

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    supportedFilesystems = [ "ntfs" ];
    initrd.systemd.enable = true;
    consoleLogLevel = 0;
    initrd.verbose = false;
    plymouth.enable = false;
    plymouth.theme = "bgrt";
    plymouth.themePackages = with pkgs; [
      # By default we would install all themes
      (adi1090x-plymouth-themes.override {
        selected_themes = [ "colorful_loop" ];
      })
    ];
    kernelParams = [
      "splash"
      "quiet"
      "loglevel=3"
      "boot.shell_on_fail"
    ];
    # kernelPackages = pkgs.linuxPackages_zen;
    kernelPackages = pkgs.linuxPackages_cachyos;
    loader.timeout = 0;
  };
  # services.scx.enable = true; # by default uses scx_rustland scheduler
}
