{
  lib,
  inputs,
  hostname,
  username,
  adminUsername,
  ...
}@args:

let
  inherit (lib) ns mkAliasOptionModule;
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    (mkAliasOptionModule
      [
        ns
        "hm"
      ]
      [
        "home-manager"
        "users"
        username
      ]
    )
    (mkAliasOptionModule
      [
        ns
        "hmNs"
      ]
      [
        "home-manager"
        "users"
        username
        ns
      ]
    )
    (mkAliasOptionModule
      [
        ns
        "hmAdmin"
      ]
      [
        "home-manager"
        "users"
        adminUsername
      ]
    )
  ];

  home-manager = {

    useGlobalPkgs = true;
    useUserPackages = true;

    extraSpecialArgs = {
      inherit inputs hostname;
      inherit (args) self selfPkgs userSettings;
    };

    users = {
      ${username} = ../../../profiles/${hostname}/home.nix;
    };
  };
}
