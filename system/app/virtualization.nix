{ pkgs, userSettings, ... }:

{
  environment.systemPackages = with pkgs; [ distrobox ];

  # Virt-manager
  programs.virt-manager.enable = true;
  users.users.${userSettings.username}.extraGroups = [ "libvirtd" ];
  virtualisation.spiceUSBRedirection.enable = true;
  virtualisation.libvirtd = {
    allowedBridges = [
      "nm-bridge"
      "virbr0"
    ];
    enable = true;
    qemu.runAsRoot = false;
  };

  # Virtual Box
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableHardening = false;
  users.extraGroups.vboxusers.members = [ "${userSettings.username}" ];

  # Enabling kvm requires network interface to be off
  virtualisation.virtualbox.host.enableKvm = false;
  # Vagrant needs this to be true to work
  virtualisation.virtualbox.host.addNetworkInterface = true;
}
