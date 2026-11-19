{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.C410l.programs.gaming.enable = lib.mkEnableOption "Steam, gamemode and emulators";

  config = lib.mkIf config.C410l.programs.gaming.enable {
    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
    programs.gamemode.enable = true;

    environment.systemPackages = with pkgs; [
      mangohud
      dolphin-emu
      retroarch-full
      C410l.es-de
    ];
  };
}
