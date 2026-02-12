{
  pkgs,
  inputs,
  userSettings,
  ...
}:

let
  backgroundImage = pkgs.fetchurl {
    url = "https://w.wallhaven.cc/full/x6/wallhaven-x6x3gz.png";
    hash = "sha256-Yvtnxaj32YXpUkXQKF1VNcApQf0v3JXGp9TNAsoJmbM=";
  };
in
{
  imports = [ inputs.stylix.nixosModules.stylix ];

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
  };

  stylix.targets.grub.enable = false;

  stylix.targets.console.enable = false;
}
