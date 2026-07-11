{ config, lib, pkgs, ... }:
let
  cfg = config.modules.desktop;
in
{
  options.modules.desktop = {
    enable = lib.mkEnableOption "desktop profile";
    dev.enable = lib.mkEnableOption "development packages";

    gaming = {
      extra-launchers.enable = lib.mkEnableOption "extra game launchers (lutris, bottles, heroic)";
      proton-extra.enable = lib.mkEnableOption "extra Proton tools (protonplus, protonup-qt)";
      modding.enable = lib.mkEnableOption "game modding tools (r2modman)";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.java.enable = true;
    programs.nix-ld.enable = true;
    programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.kdePackages.ksshaskpass.out}/bin/ksshaskpass";

    modules.fonts.enable = true;
    modules.gnome.enable = true;
    modules.gaming = {
      enable = true;
      extra-launchers.enable = cfg.gaming.extra-launchers.enable;
      proton-extra.enable = cfg.gaming.proton-extra.enable;
      modding.enable = cfg.gaming.modding.enable;
    };
    modules.hyprland.enable = true;
    modules.misc.enable = true;
    modules.system.enable = true;
    modules.media.enable = true;
    modules.browsers.enable = true;
    modules.documents.enable = true;
    modules.social.enable = true;
    modules.cli-utils.enable = true;
    modules.hardware.enable = true;
    modules.wine.enable = true;
    modules.vpn.enable = true;

    modules.dev.minimal.enable = cfg.dev.enable;
    modules.dev.editors.gui.enable = cfg.dev.enable;
    modules.dev.editors.tui.enable = cfg.dev.enable;
    modules.dev.virt.enable = cfg.dev.enable;
    modules.dev.utils.gui.enable = cfg.dev.enable;
    modules.dev.utils.tui.enable = cfg.dev.enable;
    modules.dev.langs.enable = cfg.dev.enable;
  };
}
