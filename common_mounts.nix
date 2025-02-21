{ config, pkgs, ...}:

{
  fileSystems."/home/mohammed/.config" = {
    device = "/config/home/.config";
    options = ["bind"];
  };

}
