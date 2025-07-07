{ inputs, ... }:
{
  imports = [ inputs.disko.nixosModules.default ];

  disko.devices = {
    disk.main = {
      device = "/dev/disk/by-id/nvme-KINGSTON_SNV3S1000G_50026B76870DFBE4"; # TODO: this
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

          windows = {
            size = "400G";
            type = "0700";
            content = {
              type = "filesystem";
              format = "ntfs";
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
                "@" = {
                  mountpoint = "/";
                };

                "@home" = {
                  mountOptions = [
                    "subvol=home"
                    "compress=zstd"
                  ];
                  mountpoint = "/home";
                };

                "@nix" = {
                  mountOptions = [
                    "subvol=nix"
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

    disk.games = {
      device = "/dev/disk/by-id/nvme-KINGSTON_SNV2S1000G_50026B76866DB965";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          games = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "ntfs";
              mountpoint = "/mnt/games";
              mountOptions = [
                "defaults"
                "umask=000"
                "dmask=000"
                "fmask=111"
              ];
            };
          };
        };
      };
    };
  };
}
