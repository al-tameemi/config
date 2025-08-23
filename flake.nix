{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";

      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, chaotic, nixos-hardware, lanzaboote, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./nixos/configuration.nix
        ./configuration.nix
        ./nixos/hardware-configuration.nix
        ./nixos/mounts.nix
        chaotic.nixosModules.default
        lanzaboote.nixosModules.lanzaboote

        ({pkgs, lib, ...}: {
          boot.lanzaboote = {
            enable = true;
            pkiBundle = "/var/lib/sbctl";
          };
        })
      ];
    };

    nixosConfigurations.framework = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./framework/configuration.nix
        ./configuration.nix
        ./framework/hardware-configuration.nix
        ./framework/suspend-and-hibernate.nix
        nixos-hardware.nixosModules.framework-13-7040-amd
      ];
    };
  };
}
