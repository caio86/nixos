# WireGuard VPN interfaces, e.g.
#   C410l.services.wireguard.home = { enable = true; address = [ "10.0.0.2/24" ]; peers = [ ... ]; };
# creates the wg-quick interface `wg-home`. The private key is read from the
# sops secret `wg-<hostname>-key`.
{
  lib,
  config,
  hostname,
  ...
}:
let
  inherit (lib)
    types
    mkOption
    mkEnableOption
    mkMerge
    mkIf
    mapAttrsToList
    filterAttrs
    optional
    ;
  interfaces = filterAttrs (_: cfg: cfg.enable) config.C410l.services.wireguard;

  interfaceOptions = {
    enable = mkEnableOption "the wireguard interface";
    autoStart = mkEnableOption "starting the interface at boot";

    address = mkOption {
      type = with types; listOf str;
      example = [ "10.0.0.1/24" ];
      description = "Assigned ip address for this device on the VPN network";
    };

    listenPort = mkOption {
      type = with types; nullOr port;
      default = null;
      example = 51820;
      description = "Optional port for wireguard to listen on";
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
        description = "Address of the device hosting the DNS server inside the VPN";
      };

      port = mkOption {
        type = with types; nullOr port;
        default = null;
        description = "Port of the DNS server";
      };
    };
  };
in
{
  options.C410l.services.wireguard = mkOption {
    default = { };
    type = types.attrsOf (types.submodule { options = interfaceOptions; });
    description = "Wireguard VPN interfaces";
  };

  config = mkIf (interfaces != { }) {
    sops.secrets."wg-${hostname}-key" = { };

    networking = mkMerge (
      mapAttrsToList (name: cfg: {
        wg-quick.interfaces."wg-${name}" = {
          inherit (cfg) address listenPort peers;
          autostart = cfg.autoStart;
          privateKeyFile = config.sops.secrets."wg-${hostname}-key".path;
          dns = mkIf cfg.dns.enable [ cfg.dns.address ];
        };

        firewall.allowedUDPPorts = optional (cfg.listenPort != null) cfg.listenPort;

        firewall.interfaces."wg-${name}" = mkIf cfg.dns.host {
          allowedTCPPorts = [ cfg.dns.port ];
          allowedUDPPorts = [ cfg.dns.port ];
        };
      }) interfaces
    );

    # wg-<name>-up / wg-<name>-down for interfaces that don't start at boot
    programs.zsh.shellAliases = mkMerge (
      mapAttrsToList (
        name: cfg:
        mkIf (!cfg.autoStart) {
          "wg-${name}-up" = "sudo systemctl start wg-quick-wg-${name}";
          "wg-${name}-down" = "sudo systemctl stop wg-quick-wg-${name}";
        }
      ) interfaces
    );
  };
}
