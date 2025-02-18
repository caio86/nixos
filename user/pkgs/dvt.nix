{ pkgs, ... }:

pkgs.writeShellScriptBin "dvt" ''
  nix flake init -t github:caio86/nixos#$1
  direnv allow
''
