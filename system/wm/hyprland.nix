{ pkgs, inputs, ... }:

{
  # Import wayland config
  imports = [ ./wayland.nix ];

  # Security
  security = {
    pam.services.hyprlock = { };
  };

  programs = {
    hyprland = {
      enable = true;
      xwayland = {
        enable = true;
      };
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
    };
  };

  environment.systemPackages = with pkgs; [ wl-clipboard ];
}
