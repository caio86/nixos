{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile ./tmux.conf;
  };

  # Scripts bound in zsh.nix and tmux.conf
  home.packages = with pkgs.C410l; [
    tmux-sessionizer
    tmux-navigator
    tmux-cht
    tmux-windowizer
  ];
}
