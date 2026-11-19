{ lib, config, ... }:
{
  options.C410l.programs.docker.enable = lib.mkEnableOption "Docker";

  config = lib.mkIf config.C410l.programs.docker.enable {
    virtualisation.docker = {
      enable = true;
      enableOnBoot = true;
      autoPrune.enable = true;
    };
    users.users.${config.C410l.user.name}.extraGroups = [ "docker" ];
  };
}
