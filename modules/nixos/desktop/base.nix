# Things every graphical session needs: X/Wayland, audio, fonts, keyring and
# removable-media mounting. Enabled automatically by any desktop module.
{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.C410l.desktop.enable = lib.mkEnableOption "the common graphical desktop setup";

  config = lib.mkIf config.C410l.desktop.enable {
    services.xserver.enable = true;
    environment.systemPackages = with pkgs; [
      xsel
      pavucontrol
    ];

    # Audio
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    programs.dconf.enable = true;
    services.gnome.gnome-keyring.enable = true;

    # Auto-mount USB drives etc.
    services.devmon.enable = true;
    services.gvfs.enable = true;
    services.udisks2.enable = true;

    fonts = {
      fontDir.enable = true;
      enableDefaultPackages = true;
      packages = with pkgs; [
        nerd-fonts.fira-code
        nerd-fonts.jetbrains-mono
        nerd-fonts.inconsolata
        dejavu_fonts
        font-awesome
        noto-fonts-emoji-blob-bin
      ];
      fontconfig.defaultFonts = {
        serif = [ "DejaVu Serif" ];
        sansSerif = [ "DejaVu Sans" ];
        monospace = [ "JetBrainsMono Nerd Font Mono" ];
      };
    };
  };
}
