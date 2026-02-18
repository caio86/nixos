{ pkgs, ... }:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  environment.systemPackages = [ pkgs.steam ];
}
