{
  empty = {
    path = ./devshells/empty;
    description = "dev shell with nix flakes";
  };

  py = {
    path = ./devshells/py;
    description = "python dev shell flake";
  };

  pyvenv = {
    path = ./devshells/pyvenv;
    description = "python dev shell flake with venv";
  };

  go = {
    path = ./devshells/go;
    description = "go dev shell flake";
  };

  js = {
    path = ./devshells/js;
    description = "js dev shell flake";
  };

  pop = {
    path = ./devshells/pop;
    description = "dev shell with justfile for building and running c++ code";
  };

  latex = {
    path = ./devshells/latex;
    description = "LaTeX devshell for writting PDFs";
  };

  latex-sbc = {
    path = ./devshells/latex-sbc;
    description = "LaTeX devshell for writting PDFs, with SBC template";
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
