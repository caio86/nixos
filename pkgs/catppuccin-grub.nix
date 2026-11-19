{ stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "catppuccin-grub-theme";
  version = "88f6124757331fd3a37c8a69473021389b7663ad";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "grub";
    rev = version;
    hash = "sha256-e8XFWebd/GyX44WQI06Cx6sOduCZc5z7/YhweVQGMGY=";
  };

  installPhase = ''
    mkdir -p $out
    cp -r ./src/catppuccin-mocha-grub-theme/* $out
  '';
}
