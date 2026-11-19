{ lib, ... }:
let
  locale = "pt_BR.UTF-8";
in
{
  time.timeZone = "America/Sao_Paulo";

  i18n.defaultLocale = locale;
  i18n.extraLocaleSettings = lib.genAttrs [
    "LC_ADDRESS"
    "LC_IDENTIFICATION"
    "LC_MEASUREMENT"
    "LC_MONETARY"
    "LC_NAME"
    "LC_NUMERIC"
    "LC_PAPER"
    "LC_TELEPHONE"
    "LC_TIME"
  ] (_: locale);

  # Brazilian ABNT2 keyboard with caps lock as escape
  console.keyMap = "br-abnt2";
  services.xserver.xkb = {
    layout = "br";
    variant = "";
    options = "caps:escape";
  };
}
