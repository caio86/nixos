{ pkgs, ... }:

let
  tmux-cht-languages = pkgs.callPackage ./.tmux-cht-languages.nix { };
  tmux-cht-command = pkgs.callPackage ./.tmux-cht-command.nix { };
in
pkgs.writeShellScriptBin "tmux-cht.sh" ''
  selected=$(cat ${tmux-cht-command} ${tmux-cht-languages} | fzf)
  if [[ -z $selected ]]; then
    exit 0
  fi

  read -p "Enter Query: " query

  if grep -qs "$selected" ${tmux-cht-languages}; then
    query=$(echo $query | tr ' ' '+')
    # tmux split-window -h bash -c "curl -s cht.sh/$selected/$query | less"
    tmux neww -n "$selected-$query" bash -c "echo \"curl cht.sh/$selected/$query/\" & curl cht.sh/$selected/$query & while [ : ]; do sleep 1; done"
  else
    tmux neww -n "$selected-$query" bash -c "curl -s cht.sh/$selected~$query | less"
    # tmux neww bash -c "echo \"curl cht.sh/$selected~$query/\" & curl cht.sh/$selected/$query & while [ : ]; do sleep 1; done"
  fi
''
