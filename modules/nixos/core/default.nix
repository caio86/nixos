{
  lib,
  pkgs,
  config,
  systemSettings,
  ...
}:
let
  inherit (lib) ns;
in
{
  imports = lib.${ns}.scanPaths ./.;

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
    i18n.defaultLocale = systemSettings.locale;
    i18n.extraLocaleSettings = {
      LC_ADDRESS = systemSettings.locale;
      LC_IDENTIFICATION = systemSettings.locale;
      LC_MEASUREMENT = systemSettings.locale;
      LC_MONETARY = systemSettings.locale;
      LC_NAME = systemSettings.locale;
      LC_NUMERIC = systemSettings.locale;
      LC_PAPER = systemSettings.locale;
      LC_TELEPHONE = systemSettings.locale;
      LC_TIME = systemSettings.locale;
    };
  };
}
