{
  inputs,
  self,
  pkgs,
  systemSettings,
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
  # Ensure nix flakes are enabled
  nix.package = pkgs.nixFlakes;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = builtins.attrValues self.overlays;

  # Boot loader
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;

  networking.hostName = "lua";
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;

  # Set your time zone.
  time.timeZone = systemSettings.timezone;
  # Select internationalisation properties.
  i18n.defaultLocale = systemSettings.locale;
  i18n.extraLocaleSettings = {
    LC_ADDRESS = systemSettings.locale;
    LC_IDENTIFICATION = systemSettings.locale;
    LC_MEASUREMENT = systemSettings.locale;
    LC_MONETARY = systemSettings.locale;
    LC_NAME = systemSettings.locale;
    LC_NUMERIC = systemSettings.locale;
    LC_PAPER = systemSettings.locale;
    LC_TELEPHONE = systemSettings.locale;
    LC_TIME = systemSettings.locale;
  };

  home-manager = {

    useGlobalPkgs = true;
    useUserPackages = true;

    extraSpecialArgs = {
      inherit userSettings;
      inherit inputs;
    };

    users = {
      caiol.imports = [
        inputs.sops-nix.homeManagerModules.sops
        ./home.nix
      ];
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

  programs.zsh.enable = true;

  sops.secrets."caiol_password".neededForUsers = true;

  environment.systemPackages = with pkgs; [
    vim
    neovim
    wget
    git
    home-manager
  ];

  system.stateVersion = "23.11";
}
