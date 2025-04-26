lib: ns: extraSettings:
let
  inherit (lib)
    nixosSystem
    attrNames
    genAttrs
    filterAttrs
    elem
    hasSuffix
    concatMap
    imap0
    singleton
    mod
    elemAt
    ;
in
{
  inherit ns;
  ${ns} = {
    inherit (extraSettings) userSettings systemSettings;
    flakeUtils = self: {
      forEachSystem = lib.${ns}.forEachSystem self [
        "x86_64-linux"
        "aarch64-linux"
      ];
      mkHost = lib.${ns}.mkHost self;
      mkHome = lib.${ns}.mkHome self;
    };

    #=================== Buildables =====================#

    mkHost =
      self: hostname: username: system:
      nixosSystem {
        specialArgs = {
          inherit (self) inputs;
          inherit
            self
            hostname
            username
            lib
            ;
          inherit (extraSettings) userSettings systemSettings;
          selfPkgs = self.packages.${system};
        };
        modules = [
          {
            nixpkgs.hostPlatform = system;
            nixpkgs.buildPlatform = "x86_64-linux";
          }
          ../modules/nixos
          ../profiles/${hostname}
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
          selfPkgs = self.packages.${system};
        };
      };

    forEachSystem =
      self: systems: f:
      genAttrs systems (
        system:
        f (
          import self.inputs.nixpkgs {
            inherit system;
            config.allowUnfree = true;
          }
        )
      );

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

    asserts =
      asserts:
      concatMap (a: a) (
        imap0 (
          i: elem:
          if (mod i 2) == 0 then
            singleton {
              assertion = elem;
              message = (elemAt asserts (i + 1));
            }
          else
            [ ]
        ) asserts
      );

  };
}
