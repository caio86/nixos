{
  description = "Flake of C410l";

  outputs =
    { self, nixpkgs, ... }@inputs:

    let
      # --- SYSTEM SETTINGS --- #
      systemSettings = {
        system = "x86_64-linux";
        hostname = "VEGA";
        profile = "personal";
        timezone = "America/Sao_Paulo";
        locale = "pt_BR.UTF-8";
      };

      # --- USER SETTINGS --- #
      userSettings = {
        username = "caiol";
        name = "Caio Luiz";
        email = "caioluiz86@gmail.com";
        theme = "catppuccin-mocha";
        browser = "brave";
        term = "kitty";
        editor = "nvim";
      };

      # configure pkgs
      pkgs-unstable = import inputs.nixpkgs {
        system = systemSettings.system;
        config = {
          allowUnfree = true;
        };
      };

      # Unused for now
      pkgs-stable = import inputs.nixpkgs-stable {
        system = systemSettings.system;
        config = {
          allowUnfree = true;
        };
      };

      pkgs = pkgs-unstable;

      inherit (self) outputs;

      extraSettings = {
        inherit
          inputs
          outputs
          systemSettings
          userSettings
          ;
      };

      lib = nixpkgs.lib.extend (final: _: import ./lib final "C410l" extraSettings);
      inherit (lib.${lib.ns}) mkHost mkHome;
    in
    {
      templates = import ./templates;

      overlays = import ./overlays;

      nixosConfigurations = {

        system = mkHost self "personal" "x86_64-linux";

        lua = mkHost self "lua" "x86_64-linux";

      };

      homeConfigurations = {

        user = mkHome self "personal" "x86_64-linux";
        lua = mkHome self "lua" "x86_64-linux";

      };
    };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-23.11";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-wsl.url = "github:nix-community/nixos-wsl";

    stylix.url = "github:danth/stylix";

    sops-nix.url = "github:Mic92/sops-nix";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-config.url = "github:caio86/init.lua";
    neovim-config.flake = false;
  };
}
