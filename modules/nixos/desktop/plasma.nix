{ lib, config, ... }:
let
  cfg = config.C410l.desktop.plasma;
in
{
  options.C410l.desktop.plasma = {
    enable = lib.mkEnableOption "KDE Plasma 6 with SDDM";
    autoLogin = lib.mkEnableOption "logging the primary user in automatically";
  };

  config = lib.mkIf cfg.enable {
    C410l.desktop.enable = true;

    services.desktopManager.plasma6.enable = true;
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      enableHidpi = true;
    };

    services.displayManager.autoLogin = lib.mkIf cfg.autoLogin {
      enable = true;
      user = config.C410l.user.name;
    };

    programs.kdeconnect.enable = true;
  };
}
