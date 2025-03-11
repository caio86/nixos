{ pkgs, ... }:

pkgs.stdenv.mkDerivation rec {
  name = "SKlauncher";
  version = "3.2.12";

  src = pkgs.fetchurl {
    url = "https://skmedix.pl/binaries/skl/${version}/${name}-${version}.jar";
    hash = "sha256-o5EuHptOOy1TYskRdkRMfVsaFUN8uCfxI+TKKw0Sw/k=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ pkgs.makeWrapper ];

  installPhase = ''
    mkdir -pv $out/share $out/bin
    cp ${src} $out/share/${name}-${version}.jar

    makeWrapper ${pkgs.steam-run}/bin/steam-run $out/bin/sklauncher \
      --add-flags "${pkgs.jre}/bin/java -jar $out/share/${name}-${version}.jar"
  '';

  desktopItems = [
    (pkgs.makeDesktopItem {
      name = "Minecraft";
      desktopName = "SKlauncher";
      exec = "sklauncher";
      terminal = false;
      type = "Application";
    })
  ];
}
