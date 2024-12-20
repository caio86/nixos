{
  config,
  pkgs,
  userSettings,
  ...
}:

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
    ../../user/wm/hyprland/hyprland.nix
    ../../user/lang/k8s.nix
    ../../user/lang/rust.nix
    ../../user/lang/java.nix
    ../../user/lang/golang.nix
    ../../user/lang/python.nix
    ../../user/style/gtk.nix
    ../../user/style/stylix.nix
  ];

  home.stateVersion = "23.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
    # File explorer
    gnome.nautilus
    fzf
    bat
    eza
    pass
    wl-clipboard

    # Media
    feh
    mpv
    cava
    (pkgs.makeDesktopItem {
      name = "minecraft";
      desktopName = "sklauncher";
      exec = "${pkgs.steam-run}/bin/steam-run ${pkgs.openjdk}/bin/java -jar ${config.home.homeDirectory}/Downloads/SKlauncher-3.2.8.jar";
      terminal = false;
      type = "Application";
    })

    bottles
  ];

  services.syncthing.enable = true;

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
