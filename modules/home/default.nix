# Home-manager modules for the primary user. Imported for every host by
# modules/nixos/core/home-manager.nix; optional ones use `C410l.*.enable`.
{ lib, ... }:
{
  imports = lib.C410l.scanPaths ./.;
}
