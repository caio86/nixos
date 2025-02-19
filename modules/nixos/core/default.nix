{
  lib,
  pkgs,
  username,
  systemSettings,
  ...
}:
let
  inherit (lib) ns mkOption types;
in
{
  imports = lib.${ns}.scanPaths ./.;

  options.${ns}.core = {

    username = mkOption {
      type = types.str;
      readOnly = true;
      default = username;
      description = "The name of the primary user of the system";
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

    time.timeZone = systemSettings.timezone;
  };
}
