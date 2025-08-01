self: lib: pkgs:
let
  inherit (pkgs) callPackage;
in
{
  dvd = callPackage ./dvd.nix { };
  dvt = callPackage ./dvt.nix { };
  bmv2 = callPackage ./bmv2.nix { };
  sklauncher = callPackage ./sklauncher.nix { };
  tmux-cht = callPackage ./tmux-cht.nix { };
  tmux-navigator = callPackage ./tmux-navigator.nix { };
  tmux-sessionizer = callPackage ./tmux-sessionizer.nix { };
  tmux-windowizer = callPackage ./tmux-windowizer.nix { };
}
// import ./installers.nix lib self
