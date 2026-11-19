# Home-manager config specific to vega (on top of modules/home).
{
  pkgs,
  lib,
  ...
}@args:
{
  C410l = {
    apps.brave.enable = true;
    apps.kitty.enable = true;
    dev.k8s.enable = true;
  };

  services.syncthing.enable = true;

  home.packages = with pkgs; [
    wl-clipboard
    feh
    mpv
    obsidian
    python3
    (lib.C410l.flakePkgs args "prism-launcher").default
  ];

  xdg.mimeApps.defaultApplications = lib.genAttrs [
    "image/png"
    "image/jpg"
    "image/jpeg"
  ] (_: "feh.desktop");

  home.stateVersion = "23.11";
}
