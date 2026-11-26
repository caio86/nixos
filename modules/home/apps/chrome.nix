{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.C410l.apps.chrome.enable = lib.mkEnableOption "Chrome as the default browser";

  config = lib.mkIf config.C410l.apps.chrome.enable {
    home.packages = [ pkgs.google-chrome ];

    xdg.mimeApps.defaultApplications = lib.genAttrs [
      "text/html"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
      "x-scheme-handler/about"
      "x-scheme-handler/unknown"
      "application/pdf"
    ] (_: "google-chrome.desktop");

    home.sessionVariables.DEFAULT_BROWSER = "${pkgs.google-chrome}/bin/google-chrome";
  };
}
