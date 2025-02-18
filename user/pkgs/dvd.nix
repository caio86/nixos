{ pkgs, ... }:

pkgs.writeShellScriptBin "dvd" ''
  echo "use flake \"github:caio86/nixos?dir=templates/devshells/$1\"" >> .envrc
  direnv allow
''
