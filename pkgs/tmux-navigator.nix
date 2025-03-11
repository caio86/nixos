{ pkgs, ... }:

pkgs.writeShellScriptBin "tmux-navigator" ''
  selected=$(tmux list-sessions | fzf)

  if [[ -z $selected ]]; then
    exit 0
  fi

  selected=$(echo $selected | cut -d ":" -f 1)
  tmux_running=$(pgrep tmux)

  if [[ -z $TMUX ]] && [[ $tmux_running ]]; then
    tmux attach -t $selected
    exit 0
  fi

  tmux switch-client -t $selected
''
