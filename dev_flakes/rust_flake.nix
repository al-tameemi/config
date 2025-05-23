{
    description = "Rust development environment";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        rust-overlay = {
            url = "github:oxalica/rust-overlay";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        flake-utils.url = "github:numtide/flake-utils";
    };

    outputs = { self, nixpkgs, rust-overlay, flake-utils, ... }:
        flake-utils.lib.eachDefaultSystem (system:
            let
                overlays = [ (import rust-overlay) ];
                pkgs = import nixpkgs {
                    inherit system overlays;
                };
                
                rustToolchain = pkgs.rust-bin.stable.latest.default.override {
                    extensions = [ "rust-src" "rust-analyzer" "clippy" "rustfmt" ];
                };
            in
            {
                devShells.${system}.rustdev = pkgs.mkShell {
                    buildInputs = with pkgs; [
                        rustToolchain
                        pkg-config
                        
                        # Common build dependencies
                        openssl.dev

                        # WM dependencies, probably not all required
                        wayland
                        wayland-protocols
                        libxkbcommon
                        fontconfig
                        xorg.libX11
                        xorg.libXcursor
                        xorg.libXrandr
                        xorg.libXi
                        libGL
                        libinput
                        mesa
                        freetype
                        libglvnd

                        glib
                        glib.dev
                        gtk4
                        gtk4.dev
                        # glib.gio
                        # glib.gio.dev
                        
                        # Development tools
                        cargo-watch
                        cargo-edit
                        cargo-audit
                    ];
                    
                    LD_LIBRARY_PATH = "$LD_LIBRARY_PATH:${ with pkgs; lib.makeLibraryPath [
                        wayland
                        libxkbcommon
                        fontconfig
                        libinput
                        freetype
                        libglvnd
                    ] }";

                    shellHook = ''
                        echo "Rust development environment"
                        echo "Rust: $(rustc --version)"
                        echo "Cargo: $(cargo --version)"
                    '';
                };
            }
        );
}
