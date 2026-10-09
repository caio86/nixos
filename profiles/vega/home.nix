{
  config,
  pkgs,
  lib,
  userSettings,
  ...
}@args:

let
  inherit (lib) ns;
  inherit (lib.${ns}) flakePkgs;
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = userSettings.username;
  home.homeDirectory = "/home/${userSettings.username}";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports = [
    ../../user/app/git/git.nix
    ../../user/app/browser/brave.nix
    ../../user/app/neovim/neovim.nix
    ../../user/app/terminal/kitty.nix
    ../../user/app/tmux/tmux.nix
    ../../user/shell/sh.nix
    ../../user/shell/cli-apps.nix
    ../../user/lang/k8s.nix
  ];

  home.stateVersion = "23.11"; # Please read the comment before changing.

  services.syncthing.enable = true;

  programs.fzf.enable = true;
  programs.bat.enable = true;
  programs.eza.enable = true;
  programs.password-store.enable = false;

  home.packages = with pkgs; [
    wl-clipboard

    # Media
    feh
    mpv
    cava
    (flakePkgs args "prism-launcher").default

    obsidian

    python3
  ];

  xdg.enable = true;
  xdg.userDirs = {
    enable = true;
    setSessionVariables = true;
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
