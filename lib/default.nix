lib: ns: extraSettings:
let
  inherit (lib) nixosSystem;
in
{
  inherit ns;
  ${ns} = {
    inherit (extraSettings) userSettings systemSettings;
    #=================== Buildables =====================#

    # @param {Path} config - the path to a configuration.nix file
    mkHost =
      self: hostname: system:
      nixosSystem {
        specialArgs = {
          inherit (self) inputs;
          inherit self hostname lib;
          inherit (extraSettings) userSettings systemSettings;
        };
        modules = [
          {
            nixpkgs.hostPlatform = system;
            nixpkgs.buildPlatform = "x86_64-linux";
          }
          ../profiles/${hostname}/configuration.nix
        ];
      };

    # @param {Path} config - the path to a home.nix file
    mkHome =
      self: username: system:
      let
        inherit (self.inputs) nixpkgs home-manager;
        lib = nixpkgs.lib.extend (final: _: { inherit lib; } // home-manager.lib);
      in
      home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        modules = [ ../profiles/${username}/home.nix ];

        extraSpecialArgs = {
          inherit (self) inputs;
          inherit lib self username;
          inherit (extraSettings) userSettings systemSettings;
        };
      };
  };
}
