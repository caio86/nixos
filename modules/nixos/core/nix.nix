{
  lib,
  pkgs,
  self,
  inputs,
  hostname,
  adminUsername,
  ...
}@args:
let
  inherit (lib)
    ns
    mapAttrs
    mapAttrsToList
    optionalString
    filterAttrs
    isType
    ;
  inherit (lib.${ns}) flakePkgs;
  configDir = "/home/${adminUsername}/.config/nixos";

  rebuildCmds = [
    "switch"
    "test"
    "boot"
    "build"
    "dry-build"
    "dry-activate"
    "diff"
  ];

  rebuild-scripts = map (
    cmd:
    pkgs.writeShellApplication {
      name = "rebuild-${cmd}";
      runtimeInputs = [ pkgs.nixos-rebuild ];
      text = # bash
        ''
          flake="${configDir}"
          if [ ! -d $flake ]; then
            echo "Flake does not exist locally, using remote from github"
            flake="github:caio86/nixos"
          fi
          trap "popd >/dev/null 2>&1 || true" EXIT
          pushd ~ >/dev/null 2>&1

          nixos-rebuild ${if (cmd == "diff") then "build" else cmd} \
            --use-remote-sudo --flake "$flake#${hostname}" ${optionalString (cmd != "boot") "--fast"} "$@"
          ${optionalString (cmd == "diff") "nvd diff /run/current-system result"}
        '';
    }
  ) rebuildCmds;
in
{
  adminPackages = [ pkgs.nvd ] ++ rebuild-scripts;
  # Useful for finding the exact config that built a generation
  environment.etc.current-flake.source = self;

  nixpkgs = {
    config.allowUnfree = true;
  };

  nix =
    let
      flakeInputs = filterAttrs (_: isType "flake") inputs;
    in
    {
      # Populates the nix registry with all our flake inputs `nix registry list`
      # Enables referencing flakes with short name in nix commands
      # e.g. 'nix shell n#dnsutils' or 'nix shell hyprland#wlroots-hyprland'
      registry = (mapAttrs (_: flake: { inherit flake; }) flakeInputs) // {
        self.flake = self;
        n.flake = inputs.nixpkgs;
      };

      # Add flake inputs to nix path. Enables loading flakes with <flake_name>
      # like how <nixpkgs> can be referenced.
      nixPath = mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;

      settings = {
        experimental-features = [
          "flakes"
          "nix-command"
        ];
        auto-optimise-store = true;
        substituters = [
          "https://nix-community.cachix.org"
          # "https://nix-on-droid.cachix.org"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          # "nix-on-droid.cachix.org-1:56snoMJTXmDRC1Ei24CmKoUqvHJ9XCp+nidK7qkMQrU="
        ];
      };

      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
    };

  programs.command-not-found.enable = false;
  programs.nix-index = {
    enable = true;
    package = (flakePkgs args "nix-index-database").nix-index-with-db;
  };

  programs.zsh = {
    interactiveShellInit = # bash
      ''
        inspect-host() {
          if [ -z "$1" ]; then
            echo "Usage: inspect-host <hostname>"
            return 1
          fi
          nixos-rebuild repl --flake "${configDir}#$1"
        }

        build-package() {
          NIXPKGS_ALLOW_UNFREE=1 nix build --impure --expr "with import <nixpkgs> {}; pkgs.callPackage $1 {}"
        }
      '';

    shellAliases = {
      system-size = "nix path-info --closure-size --human-readable /run/current-system";
    };
  };
}
