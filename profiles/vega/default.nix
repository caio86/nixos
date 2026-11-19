{
  lib,
  pkgs,
  hostname,
  userSettings,
  ...
}:

let
  inherit (lib) ns;
in
{
  imports = [
    ./disko.nix
    ./hardware-configuration.nix

    ../../system/app/docker.nix
    ../../system/app/wireshark.nix
    ../../system/app/gamemode.nix
    ../../system/app/steam.nix
    ../../system/app/virtualization.nix
    ../../system/security/gpg.nix
    ../../system/security/automount.nix
    ../../system/wm/plasma.nix
  ];

  services.tailscale.enable = true;
  services.netbird.enable = true;
  services.flatpak.enable = true;
  programs.kdeconnect.enable = true;

  virtualisation.vmware.host.enable = true;
  programs.mininet.enable = true;

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "${userSettings.username}";

  security.pki.certificates = [
    ''
      -----BEGIN CERTIFICATE-----
      MIIBojCCAUmgAwIBAgIQNxpfxelJM1FPvW16W11NITAKBggqhkjOPQQDAjAwMS4w
      LAYDVQQDEyVDYWRkeSBMb2NhbCBBdXRob3JpdHkgLSAyMDI2IEVDQyBSb290MB4X
      DTI2MDgwNTE4MzgzMloXDTM2MDYxMzE4MzgzMlowMDEuMCwGA1UEAxMlQ2FkZHkg
      TG9jYWwgQXV0aG9yaXR5IC0gMjAyNiBFQ0MgUm9vdDBZMBMGByqGSM49AgEGCCqG
      SM49AwEHA0IABPOt2WWXuNLjQv4NsaBgxuARnHZ8BJxHjEqcZlwn7YonZYF4Wx+O
      oNKkuDwiWtO6s/O9I5I7lj2vGIiRQk4lMNajRTBDMA4GA1UdDwEB/wQEAwIBBjAS
      BgNVHRMBAf8ECDAGAQH/AgEBMB0GA1UdDgQWBBTVNsLuVqOQuAuuSKdAv5+M0d9T
      YTAKBggqhkjOPQQDAgNHADBEAiANSrREeyzdrlaXQ5J6S/uevCHZLVzI4ZYQFsYo
      rB6SMwIgED9RhTfbdTqZyGOpXxhm/tvA15u32TcObelYp22g2m4=
      -----END CERTIFICATE-----
    ''
  ];

  services.sunshine = {
    enable = true;
    openFirewall = true;
    autoStart = true;
    capSysAdmin = true;
  };

  programs.zsh.shellAliases = {
    boot-windows = pkgs.writeShellScript "reboot_to_windows" ''
      windows_title=$(grep -i windows /boot/grub/grub.cfg | cut -d "'" -f 2)
      sudo grub-reboot "$windows_title" && sudo reboot
    '';
  };

  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PermitRootLogin = "no";
    };
  };
  services.fstrim.enable = true;

  # Bootloader.
  boot.supportedFilesystems = [
    "ntfs"
    "nfs"
  ];
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
  networking = {
    hostName = hostname;
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
    domain = "home.arpa";

    defaultGateway = "192.168.1.1";

    interfaces.enp4s0 = {
      wakeOnLan.enable = true;
    };

    firewall = {
      enable = false;
    };
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    zsh
    git

    (pkgs.${ns}.es-de)
    dolphin-emu
    retroarch-full
  ];

  fonts.fontDir.enable = true;

  # Release this machine was first installed with; don't change it.
  system.stateVersion = "23.11";
}
