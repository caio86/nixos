{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.C410l.programs.wireshark.enable = lib.mkEnableOption "Wireshark (Qt GUI)";

  config = lib.mkIf config.C410l.programs.wireshark.enable {
    programs.wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };
    users.users.${config.C410l.user.name}.extraGroups = [ "wireshark" ];
  };
}
