{
  lib,
  pkgs,
  config,
  username,
  adminUsername,
  ...
}:
let
  inherit (lib)
    ns
    mkOption
    types
    optional
    mkAliasOptionModule
    ;
  inherit (config.${ns}.core) privilegedUser;
in
{
  imports = [
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
    sops.secrets =
      {
        "${username}_password".neededForUsers = true;
      }
      // lib.optionalAttrs (username != adminUsername) {

        "${adminUsername}_password".neededForUsers = true;
      };

    users = {
      mutableUsers = true;
      defaultUserShell = pkgs.zsh;
      users = {
        ${username} =
          {
            isNormalUser = true;
            hashedPasswordFile = config.sops.secrets."${username}_password".path;
            extraGroups = optional privilegedUser "wheel";
          }
          // lib.optionalAttrs (username != adminUsername) {
            "${username}" = {
              uid = 1;
              isSystemUser = true;
              useDefaultShell = true;
              createHome = true;
              home = "/home/${adminUsername}";
              hashedPasswordFile = config.sops.secrets."${adminUsername}_password".path;
              group = "wheel";
            };
          };
      };
    };
  };
}
