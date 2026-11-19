{
  lib,
  pkgs,
  config,
  ...
}:
let
  username = config.C410l.user.name;
in
{
  options.C410l.programs.virtualisation.enable =
    lib.mkEnableOption "libvirt/virt-manager, VirtualBox and distrobox";

  config = lib.mkIf config.C410l.programs.virtualisation.enable {
    environment.systemPackages = [ pkgs.distrobox ];

    # virt-manager
    programs.virt-manager.enable = true;
    users.users.${username}.extraGroups = [ "libvirtd" ];
    virtualisation.spiceUSBRedirection.enable = true;
    virtualisation.libvirtd = {
      enable = true;
      allowedBridges = [
        "nm-bridge"
        "virbr0"
      ];
      qemu.runAsRoot = false;
    };

    # VirtualBox
    virtualisation.virtualbox.host = {
      enable = true;
      enableHardening = false;
      # KVM support requires the network interface to be off
      enableKvm = false;
      # Vagrant needs this
      addNetworkInterface = true;
    };
    users.extraGroups.vboxusers.members = [ username ];
  };
}
