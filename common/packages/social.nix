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
      # Electron picks "basic" password storage under niri (unknown XDG_CURRENT_DESKTOP),
      # which can't read the key Signal saved in GNOME Keyring. Force libsecret.
      (symlinkJoin {
        name = "signal-desktop";
        paths = [ signal-desktop ];
        nativeBuildInputs = [ makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/signal-desktop \
            --add-flags "--password-store=gnome-libsecret"
        '';
      })
    ];
  };
}
