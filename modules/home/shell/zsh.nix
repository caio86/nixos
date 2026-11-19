{ pkgs, config, ... }:
let
  aliases = {
    c = "clear";
    py = "python3";
    ls = "eza --icons -hl -T -L=1 --sort=type";
    lsa = "eza --icons -hlA -T -L=1 --sort=type";
    l = "eza -h --sort=type";
    la = "eza -hA --sort=type";
    ll = "eza -lh --sort=type";
    rg = "rg --smart-case";
    cat = "bat -p";
    open = "xdg-open";
    gitfetch = "onefetch";
    neofetch = "fastfetch";
    duh = "sudo du -h --one-file-system --max-depth=1 --threshold=100k";
    dfh = "df -h -x tmpfs -x devtmpfs";
  };
in
{
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    shellAliases = aliases;
    initContent = ''
      bindkey -s '^f' 'tmux-sessionizer\n'
      bindkey -s '^[f' 'tmux-sessionizer $PWD\n'
      bindkey -s '^t' 'tmux-navigator\n'
      bindkey -s '^[w' 'tmux-windowizer '

      # cd into a directory picked with fzf
      fzfd() {
        local dir
        dir=$(fd -t d | fzf) || return 0
        cd "$dir"
      }

      # pick .direnv directories to delete
      direnvrm() {
        fd '\.direnv' -u --type d | fzf -m | while read -r p; do rm -rf "$p"; done
      }
    '';
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
        "git-auto-fetch"
        "sudo"
        "aliases"
        "kubectl"
      ];
    };
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = aliases;
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = false;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config.global.hide_env_diff = true;
  };

  home.packages = with pkgs.C410l; [
    dvd # add a devshell template to .envrc
    dvt # `nix flake init` a devshell template
  ];
}
