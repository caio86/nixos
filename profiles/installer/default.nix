{
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

    services.openssh.enable = true;

    system.stateVersion = "24.05";
  };
}
