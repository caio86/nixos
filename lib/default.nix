lib: ns: extraSettings:
let
  inherit (lib)
    nixosSystem
    attrNames
    filterAttrs
    elem
    hasSuffix
    ;
in
{
  inherit ns;
  ${ns} = {
    inherit (extraSettings) userSettings systemSettings;
    #=================== Buildables =====================#

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

    # Get list of all nix files and directories in path for easy importing
    scanPaths =
      path:
      map (f: (path + "/${f}")) (
        attrNames (
          filterAttrs (
            path: _type: (_type == "directory") || ((path != "default.nix") && (hasSuffix ".nix" path))
          ) (builtins.readDir path)
        )
      );

    scanPathsExcept =
      path: except:
      map (f: (path + "/${f}")) (
        attrNames (
          filterAttrs (
            path: _type:
            (_type == "directory")
            || ((!elem path except) && (path != "default.nix") && (hasSuffix ".nix" path))
          ) (builtins.readDir path)
        )
      );

  };
}
