{ inputs, ... }:
{
  imports = [ inputs.disko.nixosModules.default ];

  disko.devices = {
    disk.main = {
      device = "/dev/disk/by-id/nvme-KINGSTON_SNV3S1000G_50026B76870DFBE4";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            name = "boot";
            size = "1M";
            type = "EF02";
          };

          esp = {
            name = "ESP";
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };

          # Spare partition (named "windows" on disk); not mounted by NixOS.
          windows = {
            size = "400G";
            content = {
              type = "btrfs";
            };
          };

          swap = {
            size = "12G";
            content = {
              type = "swap";
              resumeDevice = true;
            };
          };

          root = {
            name = "root";
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];

              subvolumes = {
                # btrfs applies compression from the first mount of the
                # filesystem, so it must be set on "/" to take effect.
                "@" = {
                  mountOptions = [ "compress=zstd" ];
                  mountpoint = "/";
                };

                "@home" = {
                  mountOptions = [
                    "compress=zstd"
                  ];
                  mountpoint = "/home";
                };

                "@nix" = {
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                  mountpoint = "/nix";
                };
              };
            };
          };
        };
      };
    };
  };

  boot.supportedFilesystems.ntfs = true;
  fileSystems."/mnt/games" = {
    device = "/dev/disk/by-uuid/62E68DDF1D351933";
    fsType = "ntfs";
    options = [
      "rw"
      "uid=1000"
      "gid=100"
      "umask=000"
      "user"
      "exec"
      "nofail"
      "noatime"
    ];
  };
}
