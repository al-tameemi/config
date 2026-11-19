{ ... }:
{
  imports = [ ./hardware-configuration.nix ];

  modules.username = "mohammed";
  users.users.mohammed.description = "Mohammed Al-Tameemi";

  modules.server = {
    enable = true;
    homeAssistant.enable = true;
    valheim.enable = true;
    minecraft = {
      enable = true;
      whitelist.Turbo_Fish = "2690fdf4-a573-4d5f-991d-61e1630129e4";
    };
    resolver = {
      enable = true;
      domain = "resolve.altameemi.com";
    };
    reverseProxy.enable = true;
  };

  system.stateVersion = "25.05";
}
