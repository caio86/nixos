{
  lib,
  config,
  hostname,
  ...
}:
let
  inherit (lib)
    ns
    mkMerge
    mkIf
    mapAttrsToList
    optional
    ;
  inherit (lib.${ns}) asserts;
  interfaces = config.${ns}.services.wireguard;
in
{
  assertions = mkMerge (
    mapAttrsToList (
      interface: cfg:
      asserts [
        (config.sops.secrets."wg-${hostname}-key" != null)
        "A private key for the host ${hostname} is missing"
      ]
    ) interfaces
  );

  sops.secrets."wg-${hostname}-key" = { };

  networking = mkMerge (
    mapAttrsToList (
      interface: cfg:
      mkIf cfg.enable {
        wg-quick.interfaces."wg-${interface}" = {
          address = cfg.address;
          listenPort = cfg.listenPort;
          autostart = cfg.autoStart;
          privateKeyFile = config.sops.secrets."wg-${hostname}-key".path;
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
