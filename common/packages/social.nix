{ config, lib, pkgs, ... }:
{
  options.modules.social.enable = lib.mkEnableOption "social and messaging packages";

  config = lib.mkIf config.modules.social.enable {
    nixpkgs.overlays = [
      (final: _prev: {
        pnpm_10_29_2 = final.pnpm_10;
      })
    ];

    users.users.${config.modules.username}.packages = with pkgs; [
      signal-desktop
    ];
  };
}
