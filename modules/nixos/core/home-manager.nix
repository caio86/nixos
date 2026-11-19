# Home-manager runs as part of the NixOS build (no separate `home-manager
# switch`). The user's config is every module in modules/home plus the host's
# hosts/<hostname>/home.nix.
{
  lib,
  self,
  config,
  inputs,
  hostname,
  ...
}:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    extraSpecialArgs = { inherit inputs self hostname; };

    users.${config.C410l.user.name}.imports = [
      ../../home
      ../../../hosts/${hostname}/home.nix
    ];
  };
}
