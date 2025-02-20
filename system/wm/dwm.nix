{ pkgs, ... }:

{
  imports = [
    ./pipewire.nix
    ./dbus.nix
    ./fonts.nix
    ./gnome-keyring.nix
    ./xserver.nix
  ];

  services = {
    xserver.displayManager.startx = {
      enable = true;
    };
    xserver.windowManager.dwm = {
      enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    dwm
    dmenu
    st
  ];
}
