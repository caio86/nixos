{ ... }:

{
  imports = [
    ./pipewire.nix
    ./dbus.nix
    ./fonts.nix
    ./gnome-keyring.nix
    ./xserver.nix
  ];

  # environment.systemPackages = with pkgs; [
  #   wayland
  #   (sddm-chili-theme.override {
  #     themeConfig = {
  #       background = config.stylix.image;
  #     };
  #   })
  #   (where-is-my-sddm-theme.override {
  #     themeConfig.General = {
  #       background = config.stylix.image;
  #     };
  #   })
  # ];

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    enableHidpi = true;
    # theme = "chili";
  };

  services.desktopManager.plasma6.enable = true;
}
