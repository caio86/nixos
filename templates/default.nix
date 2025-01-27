{
  devshell = {
    path = ./devshells/devshell;
    description = "dev shell with nix flakes";
  };

  python-devshell = {
    path = ./devshells/python-devshell;
    description = "python dev shell flake";
  };

  go-devshell = {
    path = ./devshells/go-devshell;
    description = "go dev shell flake";
  };

  js-devshell = {
    path = ./devshells/js-devshell;
    description = "js dev shell flake";
  };

  pop-devshell = {
    path = ./devshells/pop-devshell;
    description = "dev shell with justfile for building and running c++ code";
  };

  nixos = {
    path = ./nixosModule;
    description = "nixos flake template";
  };

  home-manager = {
    path = ./home-managerModule;
    description = "home-manager flake template";
  };

  nixosWithHome = {
    path = ./nixosWithHomeManager;
    description = "flake with nixos and home-manager configuration modules";
  };

  impermanence = {
    path = ./impermanence;
    description = "example configuration for an impermanent setup";
  };
}
