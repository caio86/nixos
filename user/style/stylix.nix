{
  pkgs,
  userSettings,
  lib,
  config,
  inputs,
  ...
}:

let
  blurredImage = pkgs.runCommand "blurredImage.png" { } ''
    ${pkgs.imagemagick}/bin/magick ${config.stylix.image} -resize 75% -blur 50x30 $out
  '';
  backgroundImage = pkgs.fetchurl {
    url = "https://w.wallhaven.cc/full/x6/wallhaven-x6x3gz.png";
    hash = "sha256-Yvtnxaj32YXpUkXQKF1VNcApQf0v3JXGp9TNAsoJmbM=";
  };
in
{
  imports = [ inputs.stylix.homeModules.stylix ];

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
        package = pkgs.nerd-fonts.jetbrains-mono;
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
