{
  pkgs,
  userSettings,
  lib,
  config,
  ...
}:

let
  blurredImage = pkgs.runCommand "blurredImage.png" { } ''
    ${pkgs.imagemagick}/bin/magick ${config.stylix.image} -resize 75% -blur 50x30 $out
  '';
  backgroundImage = pkgs.fetchurl {
    url = "https://w.wallhaven.cc/full/m3/wallhaven-m3gxg8.png";
    hash = "sha256-aSgwSZpIRKMdCNYbbpyY3GCb8C8B71SwsH6NYWVA41k=";
  };
in
{
  options.stylix = {
    blurredImage = lib.mkOption {
      type = lib.types.str;
      default = "${blurredImage}";
      description = "Blurred image";
    };
  };

  config = {
    stylix.enable = true;
    stylix.autoEnable = true;
    stylix.polarity = "dark";
    stylix.image = backgroundImage;
    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/${userSettings.theme}.yaml";

    stylix.cursor.package = pkgs.bibata-cursors;
    stylix.cursor.name = "Bibata-Modern-Ice";
    stylix.cursor.size = 24;

    stylix.fonts = {
      monospace = {
        name = "JetBrainsMono Nerd Font Mono";
        package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
      };
      sansSerif = {
        name = "DejaVu Sans";
        package = pkgs.dejavu_fonts;
      };
      serif = {
        name = "DejaVu Serif";
        package = pkgs.dejavu_fonts;
      };
      emoji = {
        name = "Noto Color Emoji";
        package = pkgs.noto-fonts-emoji-blob-bin;
      };
      sizes = {
        terminal = 12;
        applications = 12;
        popups = 12;
        desktop = 12;
      };
    };

    stylix.targets.waybar.enable = false;
  };
}
