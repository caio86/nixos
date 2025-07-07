# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  pkgs,
  hostname,
  userSettings,
  ...
}:

{
  imports = [
    ./disko.nix
    ./hardware-configuration.nix

    ../../system/hardware/openrgb.nix
    ../../system/app/docker.nix
    ../../system/app/wireshark.nix
    ../../system/app/gamemode.nix
    ../../system/app/steam.nix
    ../../system/app/virtualization.nix
    ../../system/security/gpg.nix
    ../../system/security/automount.nix
    ../../system/wm/hyprland.nix
    ../../system/style/stylix.nix
  ];


  networking.networkmanager.dns = "none";
  networking.useDHCP = false;
  networking.dhcpcd.enable = false;
  networking.nameservers = [ "192.168.0.254" ];

  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PermitRootLogin = "no";
    };
  };
  networking.firewall.enable = false;
  services.fstrim.enable = true;

  # Bootloader.
  boot.supportedFilesystems = [ "ntfs" ];
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
      configurationLimit = 8;
      theme = pkgs.stdenv.mkDerivation rec {
        pname = "catppuccin-grub-theme";
        version = "88f6124757331fd3a37c8a69473021389b7663ad";

        src = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "grub";
          rev = "${version}";
          hash = "sha256-e8XFWebd/GyX44WQI06Cx6sOduCZc5z7/YhweVQGMGY=";
        };

        installPhase = ''
          mkdir -p $out
          cp -r ./src/catppuccin-mocha-grub-theme/* $out
        '';
      };
    };
  };

  # Networking
  networking.hostName = hostname; # Define your hostname.
  networking.networkmanager.enable = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${userSettings.username} = {
    isNormalUser = true;
    description = userSettings.name;
    extraGroups = [
      "networkmanager"
      "wheel"
      "input"
      "dialout"
    ];
    packages = with pkgs; [ ];
    uid = 1000;
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    zsh
    git
  ];

  fonts.fontDir.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
