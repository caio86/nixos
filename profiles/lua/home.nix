{
  pkgs,
  config,
  userSettings,
  lib,
  ...
}:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "caiol";
  home.homeDirectory = lib.mkDefault "/home/caiol";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports = [
    ../../user/app/git/git.nix
    ../../user/app/browser/firefox.nix
    ../../user/app/terminal/kitty.nix
    ../../user/app/neovim/neovim.nix
    ../../user/app/tmux/tmux.nix
    ../../user/app/sops.nix
    ../../user/shell/sh.nix
    ../../user/shell/cli-apps.nix
    # ../../user/style/gtk.nix
    # ../../user/style/stylix.nix
  ];

  home.stateVersion = "23.11"; # Please read the comment before changing.

  # stylix.autoEnable = lib.mkForce false;

  sops.secrets = {
    "ssh_keys/lua" = {
      path = "/home/caiol/.ssh/id_lua";
    };
  };

  home.packages = with pkgs; [
    fzf
    bat
    eza
    pass
    wl-clipboard
  ];

  # TODO put this in a module later
  home.file.".xinitrc".text = ''
        xrandr --output Virtual-1 --mode 1920x1080

    if [ -f $HOME/.fehbg ]; then
      . $HOME/.fehbg
    fi

    battery() {
      battery='/sys/class/power_supply/BAT0'

      if [ -d "$battery" ]; then
        echo -n ' | '

        if grep -q 'Charging' "$battery/status"; then
          echo -n '+'
        fi

        tr -d '\n' <"$battery/capacity"

        echo '%'
      fi
    }

    while false; do
      xprop -root -set WM_NAME "$(date '+%A, %B %-d, %-I:%M %p')$(battery)"
      sleep 15
    done

    while true; do
       xsetroot -name "$( date +"%F %R" )"
       sleep 1m    # Update time every minute
    done &

    st &

    exec dwm
  '';

  xdg.enable = true;
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    music = "${config.home.homeDirectory}/Media/Músicas";
    videos = "${config.home.homeDirectory}/Media/Vídeos";
    pictures = "${config.home.homeDirectory}/Media/Imagens";
    templates = "${config.home.homeDirectory}/Modelos";
    download = "${config.home.homeDirectory}/Downloads";
    documents = "${config.home.homeDirectory}/Documentos";
    desktop = null;
    publicShare = null;
  };
  xdg.mime.enable = true;
  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "image/png" = "feh.desktop";
    "image/jpg" = "feh.desktop";
    "image/jpeg" = "feh.desktop";
  };

  home.sessionVariables = {
    EDITOR = userSettings.editor;
  };
}
