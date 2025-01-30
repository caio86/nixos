{
  devshell = {
    path = ./devshells/simple-devshell;
    description = "dev shell with nix flakes";
  };

  py-devshell = {
    path = ./devshells/py-devshell;
    description = "python dev shell flake";
  };

  pyvenv-devshell = {
    path = ./devshells/pyvenv-devshell;
    description = "python dev shell flake with venv";
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

  latex-devshell = {
    path = ./devshells/latex-devshell;
    description = "LaTeX devshell for writting PDFs";
  };

  latex-sbc-devshell = {
    path = ./devshells/latex-sbc-devshell;
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
