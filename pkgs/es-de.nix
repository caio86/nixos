{ pkgs, ... }:

pkgs.appimageTools.wrapType2 {
  pname = "es-de";
  version = "3.4.1";

  src = pkgs.fetchurl {
    url = "https://gitlab.com/es-de/emulationstation-de/-/package_files/288156961/download";
    hash = "sha256-PGGkTXONVRY9qljt5wcgtCWg32JGDATcI908pYZyNYE=";
  };

  extraInstallCommands = ''
    mkdir -p $out/share/applications

    cp -r ${
      pkgs.makeDesktopItem {
        name = "es-de";
        desktopName = "EmulationStation DE";
        genericName = "Emulator Frontend";
        comment = "EmulationStation Desktop Edition";
        exec = "es-de";
        icon = "emulationstation";
        categories = [
          "Game"
          "Emulator"
        ];
        terminal = false;
      }
    }/share/applications/* $out/share/applications/
  '';
}
