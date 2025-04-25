lib: self:

let
  inherit (lib) listToAttrs nixosSystem;
  mkInstaller = name: system: base: {
    inherit name;
    value =
      (nixosSystem {
        specialArgs = {
          inherit self base;
        };
        modules = [
          {
            nixpkgs.hostPlatform = system;
            nixpkgs.buildPlatform = "x86_64-linux";
          }
          ../profiles/installer
        ];
      }).config.system.build.isoImage;
  };
in
listToAttrs [ (mkInstaller "installer-x86_64" "x86_64-linux" "cd-dvd/installation-cd-minimal.nix") ]
