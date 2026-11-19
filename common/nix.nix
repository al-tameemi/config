{ config, lib, ... }:
{
  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    trusted-users = [ "root" config.modules.username ];
    experimental-features = [ "nix-command" "flakes" ];
  };
  nix.optimise.automatic = true;
}
