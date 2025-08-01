{ lib, pkgs, ... }:

let
  inherit (lib) ns;
  tmuxConfig = builtins.readFile ./tmux.conf;
in
{
  programs.tmux.enable = true;
  programs.tmux.extraConfig = tmuxConfig;

  home.packages = with pkgs.${ns}; [
    tmux-sessionizer
    tmux-navigator
    tmux-cht
    tmux-windowizer
  ];
}
