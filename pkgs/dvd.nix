{ pkgs, ... }:

pkgs.writeShellScriptBin "dvd" ''
  if [[ -z "$1" ]]; then
    echo "Usage: dvd <template>"
    exit 1
  fi

  echo "use flake \"github:caio86/nixos?dir=templates/devshells/$1\"" >> .envrc
  direnv allow
''
