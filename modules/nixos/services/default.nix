{ lib, ... }:
let
  inherit (lib)
    ns
    types
    mkOption
    mkEnableOption
    ;
in
{
  imports = lib.${ns}.scanPaths ./.;

  options.${ns}.services =
    let
      wgInterfaceOptions = {
        enable = mkEnableOption "The wireguard interface";
        autoStart = mkEnableOption "auto start";

        address = mkOption {
          type = types.str;
          default = null;
          example = "10.0.0.1";
          description = "Assigned ip address for this device on the VPN network";
        };

        subnet = mkOption {
          type = types.int;
          default = null;
          example = 24;
          description = "Subnet of the wireguard network";
        };

        listenPort = mkOption {
          type = with types; nullOr port;
          default = null;
          example = "51820";
          description = ''
            Optional port for wireguard to listen on.
          '';
        };

        peers = mkOption {
          type = with types; listOf attrs;
          default = [ ];
          description = "Wireguard peers";
        };

        dns = {
          enable = mkEnableOption "a custom DNS server for the VPN";
          host = mkEnableOption "hosting the custom DNS server on this host";

          address = mkOption {
            type = types.str;
            default = null;
            description = "Address of the device hosting the DNS server inside the VPN";
          };

          port = mkOption {
            type = with types; nullOr port;
            default = null;
            description = "Port of the DNS server";
          };

          domains = mkOption {
            type = with types; attrsOf str;
            default = { };
            description = ''
              Attribute set of domains mapped to addresses.
            '';
          };
        };
      };
    in
    {
      wireguard = mkOption {
        default = { };
        type = types.attrsOf (types.submodule { options = wgInterfaceOptions; });
        description = "Wireguard VPN interfaces";
      };
    };
}
