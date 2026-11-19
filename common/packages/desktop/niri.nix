{ config, lib, pkgs, ... }:
{
  options.modules.niri.enable = lib.mkEnableOption "Niri compositor";

  config = lib.mkIf config.modules.niri.enable {
    modules.wm-support.enable = true;
    programs.niri.enable = true;

    # Steam is an X11 app (via xwayland-satellite) and ignores the 1.5 output scale.
    # Set in the session env (not just niri's `environment`) so apps launched from Dux inherit it.
    environment.sessionVariables.STEAM_FORCE_DESKTOPUI_SCALING = "1.5";

    # Dux Shell (formerly DankMaterialShell); started as a systemd user service
    programs.dux-shell.enable = true;
    # The module's unit is WantedBy=graphical-session.target, which every session
    # (GNOME included) reaches. Only run it when the session is niri.
    systemd.user.services.dms.unitConfig.ConditionEnvironment = "XDG_CURRENT_DESKTOP=niri";

    environment.systemPackages = with pkgs; [
      xwayland-satellite
    ];
  };
}
