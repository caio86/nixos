{ inputs, config, ... }:

let
  sopsFolder = builtins.toString inputs.nix-secrets;
in
{
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  sops = {

    defaultSopsFile = "${sopsFolder}/secrets.yaml";
    validateSopsFiles = false;

    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
  };
}
