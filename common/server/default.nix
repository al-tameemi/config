# Headless-server modules. Everything is gated behind modules.server.* options.
# Imported by `mkServer` in flake.nix.
{ ... }:
{
  imports = [
    ../packages/options.nix # modules.username
    ../locale.nix
    ../nix.nix
    ./base.nix
    ./home-assistant.nix
    ./minecraft.nix
    ./valheim.nix
    ./reverse-proxy.nix
    ./resolver.nix
  ];
}
