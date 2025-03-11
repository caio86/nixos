{ pkgs, ... }:

pkgs.writeShellScriptBin "tmux-sessionizer" ''
  if [[ $# -eq 1 ]]; then
    selected=$1
  else
    selected=$(fd . ~/ ~/projetos ~/projetos/pessoal/ ~/projetos/estudo/ -u --min-depth 1 --max-depth 1 --type d | fzf)
    # selected=$(find ~/work/builds ~/projects ~/ ~/work ~/personal ~/personal/yt -mindepth 1 -maxdepth 1 -type d | fzf)
  fi

  if [[ -z $selected ]]; then
    exit 0
  fi

  selected_name=$(basename "$selected" | tr . _)
  tmux_running=$(pgrep tmux)

  # echo $selected
  # echo $selected_name
  # echo $tmux_running

  if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -s $selected_name -c $selected
    exit 0
  fi

  if ! tmux has-session -t=$selected_name 2>/dev/null; then
    tmux new-session -ds $selected_name -c $selected
  fi

  if [[ -z $TMUX ]] && [[ $tmux_running ]]; then
    tmux attach -t $selected_name
    exit 0
  fi

  tmux switch-client -t $selected_name
''
