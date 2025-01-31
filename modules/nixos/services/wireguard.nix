{ lib, config, ... }:
let
  inherit (lib)
    ns
    mkMerge
    mkIf
    mapAttrsToList
    optional
    ;
  interfaces = config.${ns}.services.wireguard;
in
{
  networking = mkMerge (
    mapAttrsToList (
      interface: cfg:
      mkIf cfg.enable {
        wg-quick.interfaces."wg-${interface}" = {
          address = [ "${cfg.address}/${toString cfg.subnet}" ];
          listenPort = cfg.listenPort;
          autostart = cfg.autoStart;
          privateKeyFile = config.sops.secrets."wg-${interface}-key".path;
          dns = mkIf cfg.dns.enable [ cfg.dns.address ];

          peers = cfg.peers;
        };

        firewall.allowedUDPPorts = optional (cfg.listenPort != null) cfg.listenPort;

        firewall.interfaces."wg-${interface}" = mkIf cfg.dns.host {
          allowedTCPPorts = [ cfg.dns.port ];
          allowedUDPPorts = [ cfg.dns.port ];
        };
      }
    ) interfaces
  );

  programs.zsh.shellAliases = mkMerge (
    mapAttrsToList (
      interface: cfg:
      mkIf (cfg.enable && !cfg.autoStart) {
        "wg-${interface}-up" = "sudo systemctl start wg-quick-wg-${interface}";
        "wg-${interface}-down" = "sudo systemctl stop wg-quick-wg-${interface}";
      }
    ) interfaces
  );
}
