{ config, lib, pkgs, ... }:
let
  mpv-full = pkgs.mpv-unwrapped.override { ffmpeg = pkgs.ffmpeg-full; };
in
{
  options.modules.media.enable = lib.mkEnableOption "media packages";

  config = lib.mkIf config.modules.media.enable {
    users.users.${config.modules.username}.packages = with pkgs; [
      mpv-full
      ffmpeg
      pavucontrol
      easyeffects
      # GStreamer
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-ugly
      gst_all_1.gst-libav
      gst_all_1.gst-vaapi
    ];
  };
}
