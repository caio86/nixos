{ selfPkgs, ... }:

let
  tmuxConfig = builtins.readFile ./tmux.conf;
in
{
  programs.tmux.enable = true;
  programs.tmux.extraConfig = tmuxConfig;

  home.packages = with selfPkgs; [
    tmux-sessionizer
    tmux-navigator
    tmux-cht
    tmux-windowizer
  ];
}
