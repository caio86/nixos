{
  inputs,
  self,
  pkgs,
  hostname,
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
  boot.loader.grub.theme = pkgs.stdenv.mkDerivation rec {
    pname = "minegrub-theme";
    version = "b1caebbd5ab96f6afbfcd735b58fab9b9d8cf54b";

    src = pkgs.fetchFromGitHub {
      owner = "Lxtharia";
      repo = "${pname}";
      rev = "${version}";
      hash = "sha256-OLFbGacrRFqSoqUc+pf66eb1xd0aU/crKfpiWSpJ0fw=";
    };

    installPhase = ''
      mkdir -p $out
      cp -r ./minegrub-theme/* $out
    '';
  };

  networking.hostName = hostname;
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;

  system.stateVersion = "23.11";
}
