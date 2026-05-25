{ ... }:
{
  imports = [
    ./dev-minimal.nix
    ./editors/gui.nix
    ./editors/tui.nix
    ./virt/default.nix
    ./utils/gui.nix
    ./utils/tui.nix
    ./langs/default.nix
  ];
}
