# The single source of truth for who uses this machine. Other modules read
# `config.C410l.user.*` (and home-manager modules read `osConfig.C410l.user.*`).
{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkOption types optional;
  cfg = config.C410l.user;
in
{
  options.C410l.user = {
    name = mkOption {
      type = types.str;
      default = "caiol";
      description = "Login name of the primary user";
    };

    fullName = mkOption {
      type = types.str;
      default = "Caio Luiz";
    };

    email = mkOption {
      type = types.str;
      default = "caioluiz86@gmail.com";
    };

    gitName = mkOption {
      type = types.str;
      default = "caio86";
      description = "Name used for git commits (GitHub handle)";
    };

    isAdmin = mkOption {
      type = types.bool;
      default = true;
      description = "Whether the primary user is in the wheel group";
    };
  };

  config = {
    # Password hash comes from the nix-secrets repo (see sops.nix)
    sops.secrets."${cfg.name}_password".neededForUsers = true;

    users = {
      mutableUsers = true;
      defaultUserShell = pkgs.zsh;
      users.${cfg.name} = {
        isNormalUser = true;
        uid = 1000;
        description = cfg.fullName;
        hashedPasswordFile = config.sops.secrets."${cfg.name}_password".path;
        extraGroups = [
          "networkmanager"
          "input"
          "dialout"
        ]
        ++ optional cfg.isAdmin "wheel";
      };
    };
  };
}
