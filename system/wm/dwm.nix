{ pkgs, ... }:

{
  imports = [
    ./pipewire.nix
    ./dbus.nix
    ./fonts.nix
    ./gnome-keyring.nix
    ./xserver.nix
  ];

  services.xserver = {
    windowManager.dwm = {
      enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    dwm
    dmenu
    st
  ];
}
