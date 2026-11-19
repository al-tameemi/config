{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Separate, stable pin used only by the minipc server (see nixosConfigurations.minipc).
    # Bump to a new release branch deliberately; `nix flake update` only moves the rev within it.
    nixpkgs-minipc.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.2.0";
      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-programs-sqlite = {
      url = "github:wamserma/flake-programs-sqlite";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    comfy-portal.url = "git+ssh://git@github.com/al-tameemi/comfy-portal.git";
  };

  outputs = { self, nixpkgs, nixos-hardware, lanzaboote, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./nixos/configuration.nix
        ./configuration.nix
        lanzaboote.nixosModules.lanzaboote
        inputs.comfy-portal.nixosModules.default

        ({pkgs, lib, ...}: {
          boot.lanzaboote = {
            enable = true;
            pkiBundle = "/var/lib/sbctl";
          };
        })
      ];
    };

    nixosConfigurations.framework = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./framework/configuration.nix
        ./configuration.nix
        ./framework/hardware-configuration.nix
        ./framework/suspend-and-hibernate.nix
        nixos-hardware.nixosModules.framework-13-7040-amd
      ];
    };

    # Headless server on its own stable nixpkgs; deliberately does not import the
    # shared desktop ./configuration.nix.
    nixosConfigurations.minipc = inputs.nixpkgs-minipc.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [ ./minipc/configuration.nix ];
    };
  };
}
