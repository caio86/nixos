{
  inputs,
  self,
  pkgs,
  userSettings,
  config,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    (import ./disko.nix { device = "/dev/sda"; })
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager
    ../../system/security/sops.nix
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

  networking.hostName = "lua";
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;

  home-manager = {

    useGlobalPkgs = true;
    useUserPackages = true;

    extraSpecialArgs = {
      inherit userSettings;
      inherit inputs;
    };

    users = {
      caiol.imports = [ ./home.nix ];
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."caiol" = {
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets.caiol_password.path;
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  sops.secrets."caiol_password".neededForUsers = true;

  system.stateVersion = "23.11";
}
