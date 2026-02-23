{
  lib,
  pkgs,
  config,
  ...
}:

let
  inherit (lib) ns;
  myAliases = {
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
    fzfd = ''
      escolhido=$(fd -t d | fzf)
      if [ -z "$escolhido" ]; then
        return 0
      fi

      cd $escolhido
    '';
    direnvrm = ''
      fd "\.direnv" -u --type d | fzf -m | while read p; do rm -rf "$p"; done
    '';
  };
in

{
  programs.starship.enable = true;
  programs.starship.enableBashIntegration = false;
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    shellAliases = myAliases;
    initContent = ''
      bindkey -s '^f' 'tmux-sessionizer\n'
      bindkey -s '^[f' 'tmux-sessionizer $PWD\n'
      bindkey -s '^t' 'tmux-navigator\n'
      bindkey -s '^[w' 'tmux-windowizer '
    '';
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
        "git-auto-fetch"
        "command-not-found"
        "sudo"
        "aliases"
        "kubectl"
      ];
    };
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = myAliases;
  };

  home.packages = with pkgs; [
    disfetch
    lolcat
    cowsay
    onefetch
    bat
    eza
    bottom
    fd
    direnv
    nix-direnv

    pkgs.${ns}.dvd
    pkgs.${ns}.dvt
  ];

  programs.direnv.enable = true;
  programs.direnv.enableZshIntegration = true;
  programs.direnv.nix-direnv.enable = true;
  programs.direnv.config = {
    global = {
      hide_env_diff = true;
    };
  };
}
