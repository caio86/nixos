{
  lib,
  pkgs,
  config,
  username,
  adminUsername,
  ...
}:
let
  inherit (lib) ns optional;
  inherit (config.${ns}.core) privilegedUser;
in
{
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
}
