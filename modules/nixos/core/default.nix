{
  lib,
  pkgs,
  config,
  username,
  adminUsername,
  systemSettings,
  ...
}:
let
  inherit (lib)
    ns
    mkOption
    types
    mkAliasOptionModule
    ;
in
{
  imports = lib.${ns}.scanPaths ./. ++ [
    (mkAliasOptionModule [ "userPackages" ] [
      "users"
      "users"
      username
      "packages"
    ])

    (mkAliasOptionModule [ "adminPackages" ] [
      "users"
      "users"
      adminUsername
      "packages"
    ])

  ];

  options.${ns}.core = {

    username = mkOption {
      type = types.str;
      readOnly = true;
      default = username;
      description = "The name of the primary user of the system";
    };

    adminUsername = mkOption {
      type = types.str;
      readOnly = true;
      default = "caiol";
      description = "The username of the admin user that exists on all hosts";
    };

    privilegedUser = mkOption {
      type = types.bool;
      default = true;
      description = "If the primary user is in wheel group";
    };

  };

  config = {
    programs.zsh.enable = true;
    environment.defaultPackages = [ ];

    environment.systemPackages = with pkgs; [
      vim
      git
      fd
      ripgrep
      tree
    ];

    _module.args = {
      inherit (config.${ns}.core) adminUsername;
    };

    time.timeZone = systemSettings.timezone;
  };
}
