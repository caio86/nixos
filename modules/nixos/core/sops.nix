{ inputs, ... }:

let
  sopsFolder = builtins.toString inputs.nix-secrets;
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {

    defaultSopsFile = "${sopsFolder}/secrets.yaml";
    validateSopsFiles = false;

    age = {
      # automatically import host SSH keys as age keys
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    };
  };
}
