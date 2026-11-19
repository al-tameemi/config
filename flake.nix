{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Separate, stable pin used only by server hosts (see mkServer below).
    # Bump to a new release branch deliberately; `nix flake update` only moves the rev within it.
    nixpkgs-server.url = "github:NixOS/nixpkgs/nixos-26.05";
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

  outputs = { self, nixpkgs, nixos-hardware, lanzaboote, ... }@inputs:
  let
    # Headless server on the stable nixpkgs-server pin. Hostname = attribute name;
    # host-specific config lives in ./<name>/configuration.nix.
    mkServer = name: extraModules: inputs.nixpkgs-server.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./common/server
        { networking.hostName = name; }
        (./. + "/${name}/configuration.nix")
      ] ++ extraModules;
    };
  in {
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

    nixosConfigurations.minipc = mkServer "minipc" [ ];
  };
}
