{
  description = "Flake of C410l";

  outputs =
    { self, ... }@inputs:

    let
      # --- SYSTEM SETTINGS --- #
      systemSettings = {
        system = "x86_64-linux";
        hostname = "VEGA";
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
      nixpkgs-unstable = inputs.nixpkgs;

      nixpkgs-stable = inputs.nixpkgs-stable;

      nixpkgs = nixpkgs-unstable;

      extraSettings = {
        inherit systemSettings userSettings;
      };

      lib = nixpkgs.lib.extend (final: _: import ./lib final "C410l" extraSettings);
      inherit (lib.${lib.ns}.flakeUtils self) mkHost mkHome forEachSystem;
    in
    {
      templates = import ./templates;
      overlays = import ./overlays;
      packages = forEachSystem (pkgs: import ./pkgs self lib pkgs);

      nixosConfigurations = {

        vega = mkHost "vega" "caiol" "x86_64-linux";

        lua = mkHost "lua" "caiol" "x86_64-linux";

      };

      homeConfigurations = {

        user = mkHome "vega" "x86_64-linux";
        lua = mkHome "lua" "x86_64-linux";

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

    nix-secrets.url = "git+ssh://git@gitlab.com/caio86/nix-secrets.git?ref=main&shallow=1";
    nix-secrets.inputs.nixpkgs.follows = "nixpkgs";
  };
}
