{
  inputs,
  self,
  selfPkgs,
  hostname,
  userSettings,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    (import ./disko.nix { device = "/dev/sda"; })
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager
    ../../system/security/gpg.nix
    ../../system/app/docker.nix
    ../../system/wm/dwm.nix
    ../../system/style/stylix.nix
  ];

  nixpkgs.overlays = builtins.attrValues self.overlays;

  # Boot loader
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;

  networking.hostName = hostname;
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;

  home-manager = {

    useGlobalPkgs = true;
    useUserPackages = true;

    extraSpecialArgs = {
      inherit userSettings;
      inherit inputs;
      inherit selfPkgs;
    };

    users = {
      caiol.imports = [ ./home.nix ];
    };
  };

  system.stateVersion = "23.11";
}
