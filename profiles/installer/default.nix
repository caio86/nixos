{
  self,
  pkgs,
  base,
  modulesPath,
  ...
}:

{
  imports = [ "${modulesPath}/installer/${base}" ];

  config = {
    isoImage.compressImage = false;

    environment.systemPackages = with pkgs; [
      self.inputs.nix-secrets.packages.${pkgs.system}.bootstrap-kit
      gitMinimal
      zellij
      bottom
      neovim
    ];

    nix.settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      warn-dirty = false;
    };

    zramSwap.enable = true;

    services.openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
      settings.KbdInteractiveAuthentication = false;

      knownHosts = {
        "github.com".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
        "gitlab.com".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf";
      };

    };

    users.users.root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO02TcigmdT4nw+YbSdPM0Irs8Lu9YgINYjzzodfmvaF caiol@vega"
    ];

    system.stateVersion = "24.05";
  };
}
