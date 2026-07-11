{ config, lib, inputs, ... }:
{
  imports = [ inputs.flake-programs-sqlite.nixosModules.programs-sqlite ];

  options.modules.programs-sqlite.enable = lib.mkEnableOption "flake programs sqlite";
}
