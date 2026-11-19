{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.C410l.apps.brave.enable = lib.mkEnableOption "Brave as the default browser";

  config = lib.mkIf config.C410l.apps.brave.enable {
    home.packages = [ pkgs.brave ];

    xdg.mimeApps.defaultApplications = lib.genAttrs [
      "text/html"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
      "x-scheme-handler/about"
      "x-scheme-handler/unknown"
      "application/pdf"
    ] (_: "brave-browser.desktop");

    home.sessionVariables.DEFAULT_BROWSER = "${pkgs.brave}/bin/brave";
  };
}
