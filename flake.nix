{
  description = "Flake of C410l";

  outputs =
    { self, nixpkgs, ... }:
    let
      lib = nixpkgs.lib.extend (final: _: import ./lib final);
      inherit (lib.C410l) mkHost;

      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations = {
        vega = mkHost self "vega" system;
      };

      # Own packages (pkgs/) and the installer ISO: `nix build .#installer-x86_64`
      packages.${system} = import ./pkgs self lib pkgs;

      # `nix flake init -t github:caio86/nixos#<name>`
      templates = import ./templates;
    };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    prism-launcher.url = "github:Diegiwg/PrismLauncher-Cracked";

    neovim-config.url = "github:caio86/nvim";
    neovim-config.flake = false;

    nix-secrets.url = "git+ssh://git@gitlab.com/caio86/nix-secrets.git?ref=main&shallow=1";
    nix-secrets.inputs.nixpkgs.follows = "nixpkgs";
  };
}
