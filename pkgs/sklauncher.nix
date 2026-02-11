{ pkgs, ... }:

let
  desktopItem = pkgs.makeDesktopItem {
    name = "Minecraft";
    desktopName = "SKlauncher";
    exec = "sklauncher";
    terminal = false;
    type = "Application";
    genericName = "Minecraft Launcher";
  };
in
pkgs.stdenv.mkDerivation rec {
  name = "SKlauncher";
  version = "3.2.18";

  src = pkgs.fetchurl {
    url = "https://skmedix.pl/binaries/skl/${version}/${name}-${version}.jar";
    hash = "sha256-Jac+N3Ch2NFLzlPokg4uiTqsw8cV0Psi+HjvIJDQOGM=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ pkgs.makeWrapper ];

  installPhase = ''
    mkdir -pv $out/share $out/bin $out/share/applications
    cp ${src} $out/share/${name}-${version}.jar
    cp -at $out/share/applications ${desktopItem}

    makeWrapper ${pkgs.steam-run}/bin/steam-run $out/bin/sklauncher \
      --add-flags "${pkgs.jre}/bin/java -jar $out/share/${name}-${version}.jar"
  '';
}
