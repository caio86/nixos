# Imports every module below this directory. Modules in core/ are always
# active; everything else is switched on per host with `C410l.*.enable`.
{ lib, ... }:
{
  imports = lib.C410l.scanPaths ./.;
}
