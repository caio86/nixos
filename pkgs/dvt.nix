{ pkgs, ... }:

pkgs.writeShellScriptBin "dvt" ''
  if [[ -z "$1" ]]; then
    echo "Usage: dvt <template>"
    exit 1
  fi

  nix flake init -t github:caio86/nixos#$1
  direnv allow
''
