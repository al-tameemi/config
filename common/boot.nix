{ config, lib, ... }:
let
  cfg = config.modules.boot;
in
{
  options.modules.boot = {
    enable = lib.mkEnableOption "boot configuration";
    silent = lib.mkEnableOption "silent/splash boot";
  };

  config = lib.mkIf cfg.enable {
    boot = {
      loader.efi.canTouchEfiVariables = true;
      supportedFilesystems = [ "ntfs" ];
      kernelParams = [ "preempt=full" "boot.shell_on_fail" ]
        ++ lib.optionals cfg.silent [ "splash" "quiet" "loglevel=3" ];
      consoleLogLevel = lib.mkIf cfg.silent 0;
      plymouth.theme = lib.mkIf cfg.silent "bgrt";
      loader.timeout = lib.mkIf cfg.silent 0;
    };
  };
}
