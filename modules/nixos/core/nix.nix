{ self, pkgs, ... }:
{
  environment.systemPackages = [ pkgs.nvd ];
  # Useful for finding the exact config that built a generation
  environment.etc.current-flake.source = self;

  nixpkgs = {
    config.allowUnfree = true;
  };

  nix = {
    settings = {
      experimental-features = [
        "flakes"
        "nix-command"
      ];
      auto-optimise-store = true;
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  programs.zsh = {
    shellAliases = {
      system-size = "nix path-info --closure-size --human-readable /run/current-system";
    };
  };
}
