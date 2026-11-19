{ config, ... }:
let
  home = config.home.homeDirectory;
in
{
  xdg.enable = true;
  xdg.userDirs = {
    enable = true;
    setSessionVariables = true;
    createDirectories = true;
    music = "${home}/Media/Músicas";
    videos = "${home}/Media/Vídeos";
    pictures = "${home}/Media/Imagens";
    templates = "${home}/Modelos";
    download = "${home}/Downloads";
    documents = "${home}/Documentos";
    desktop = null;
    publicShare = null;
  };
  xdg.mimeApps.enable = true;
}
