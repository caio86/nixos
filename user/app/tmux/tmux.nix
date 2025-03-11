{ pkgs, ... }:

let
  tmuxConfig = builtins.readFile ./tmux.conf;
in
{
  programs.tmux.enable = true;
  programs.tmux.extraConfig = tmuxConfig;

  home.packages = [
    (pkgs.callPackage ../../../pkgs/tmux-sessionizer.nix { })
    (pkgs.callPackage ../../../pkgs/tmux-navigator.nix { })
    (pkgs.callPackage ../../../pkgs/tmux-cht.sh.nix { })
    (pkgs.callPackage ../../../pkgs/tmux-windowizer.nix { })
  ];
}
