{ lib, ... }:
let
  inherit (lib) ns;
in
{
  imports = lib.${ns}.scanPaths ./.;
}
