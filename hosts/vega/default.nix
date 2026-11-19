# Desktop PC: Plasma, gaming, virtualisation. Dual-boots Windows from
# another disk (picked up by os-prober).
{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  C410l = {
    desktop.plasma = {
      enable = true;
      autoLogin = true;
    };
    programs = {
      docker.enable = true;
      gaming.enable = true;
      virtualisation.enable = true;
      wireshark.enable = true;
    };
  };

  # ---------- Boot ----------
  boot.loader = {
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot";
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
      configurationLimit = 8;
      theme = pkgs.C410l.catppuccin-grub;
    };
  };

  # ---------- Network ----------
  networking = {
    domain = "home.arpa";
    defaultGateway = "192.168.1.1";
    interfaces.enp4s0.wakeOnLan.enable = true;
    firewall.enable = false;
  };

  services.tailscale.enable = true;
  services.netbird.enable = true;

  services.openssh = {
    enable = true;
    openFirewall = true;
    settings.PermitRootLogin = "no";
  };

  # Root CA of the Caddy server on the home network
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

  # ---------- Services & apps ----------
  # Game streaming host (Moonlight client)
  services.sunshine = {
    enable = true;
    openFirewall = true;
    autoStart = true;
    capSysAdmin = true;
  };

  services.flatpak.enable = true;
  services.fstrim.enable = true;
  virtualisation.vmware.host.enable = true;
  programs.mininet.enable = true;

  environment.systemPackages = [
    (pkgs.writeShellApplication {
      name = "boot-windows";
      text = ''
        windows_title=$(grep -i windows /boot/grub/grub.cfg | cut -d "'" -f 2)
        sudo grub-reboot "$windows_title" && sudo reboot
      '';
    })
  ];

  # Release this machine was first installed with; don't change it.
  system.stateVersion = "23.11";
}
