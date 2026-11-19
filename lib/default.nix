# Helpers available everywhere as `lib.C410l.*`.
lib:
let
  inherit (lib)
    nixosSystem
    filter
    hasSuffix
    ;
in
{
  C410l = {
    # Build a NixOS system from hosts/<hostname>. All modules in
    # modules/nixos are always imported; hosts turn features on via options.
    mkHost =
      self: hostname: system:
      nixosSystem {
        specialArgs = {
          inherit (self) inputs;
          inherit self hostname lib;
        };
        modules = [
          {
            nixpkgs.hostPlatform = system;
            # Own packages from pkgs/ are available as `pkgs.C410l.<name>`
            nixpkgs.overlays = [ (_: _: { C410l = self.packages.${system}; }) ];
          }
          ../modules/nixos
          ../hosts/${hostname}
        ];
      };

    # Packages of a flake input for the current system, e.g.
    # `(flakePkgs args "prism-launcher").default`
    flakePkgs =
      { inputs, pkgs, ... }: flake: inputs.${flake}.packages.${pkgs.stdenv.hostPlatform.system};

    # Every .nix file below `dir` (recursively), except default.nix files.
    # Used so that dropping a file into modules/ is enough to import it.
    scanPaths =
      dir:
      filter (path: hasSuffix ".nix" path && baseNameOf path != "default.nix") (
        lib.filesystem.listFilesRecursive dir
      );

    # Adding multiple EXIT traps in a bash script is a pain because they
    # overwrite each other. This makes that easier.
    exitTrapBuilder = # bash
      ''
        exit_trap_command=""
        function call_exit_traps {
          eval "$exit_trap_command"
        }
        trap call_exit_traps EXIT

        function add_exit_trap {
          local to_add=$1
          if [ -z "$exit_trap_command" ]; then
            exit_trap_command="$to_add"
          else
            exit_trap_command="$exit_trap_command; $to_add"
          fi
        }
      '';
  };
}
