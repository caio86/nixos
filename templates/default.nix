{
  devshell = {
    path = ./devshells/simple;
    description = "dev shell with nix flakes";
  };

  devshell-py = {
    path = ./devshells/py;
    description = "python dev shell flake";
  };

  devshell-pyvenv = {
    path = ./devshells/pyvenv;
    description = "python dev shell flake with venv";
  };

  devshell-go = {
    path = ./devshells/go;
    description = "go dev shell flake";
  };

  devshell-js = {
    path = ./devshells/js;
    description = "js dev shell flake";
  };

  devshell-pop = {
    path = ./devshells/pop;
    description = "dev shell with justfile for building and running c++ code";
  };

  devshell-latex = {
    path = ./devshells/latex;
    description = "LaTeX devshell for writting PDFs";
  };

  devshell-latex-sbc = {
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
