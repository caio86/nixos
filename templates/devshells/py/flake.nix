{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      devShells = forAllSystems (
        pkgs:
        let
          python = pkgs.python3;

          runtime = [
            python
          ];

          tools = with pkgs; [
            basedpyright
            ruff
          ];

          env = pkgs.lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
            LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
              pkgs.stdenv.cc.cc.lib
              pkgs.zlib
            ];
          };

          shellHook = ''
            test -d .venv || ${python.interpreter} -m venv .venv
            source .venv/bin/activate
          '';
        in
        {
          default = pkgs.mkShell {
            packages = runtime ++ tools;
            inherit env shellHook;
          };

          runtime = pkgs.mkShell {
            packages = runtime;
            inherit env shellHook;
          };
        }
      );
    };
}
