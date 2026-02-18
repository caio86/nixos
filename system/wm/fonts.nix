{ pkgs, ... }:

{
  # Fonts are nice to have
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      # Fonts
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts.inconsolata
      dejavu_fonts
      font-awesome
      noto-fonts-emoji-blob-bin
    ];

    fontconfig = {
      defaultFonts = {
        serif = [ "DejaVu Serif" ];
        sansSerif = [ "DejaVu Sans" ];
        monospace = [ "JetBrainsMono Nerd Font Mono" ];
      };
    };
  };
}
