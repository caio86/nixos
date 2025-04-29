{
  lib,
  self,
  pkgs,
  base,
  modulesPath,
  ...
}:

let
  inherit (lib) ns;
  installScript = pkgs.writeShellApplication {
    name = "install-host";

    runtimeInputs = with pkgs; [
      self.inputs.nix-secrets.packages.${pkgs.system}.bootstrap-kit
      disko
      gitMinimal
    ];

    text = ''
      if [ "$(id -u)" != "0" ]; then
        echo "This script must be run as root" 1>&2
        exit 1
      fi

      if [ "$#" -ne 1 ]; then
        echo "Usage: install-host <hostname>"
        exit 1
      fi
      ${lib.${ns}.exitTrapBuilder}

      hostname=$1

      flake="/root/nixos"
      if [ ! -d "$flake" ]; then
        read -p "Use the flake this ISO was built with? (default is to fetch latest from GitHub) (y/N): " -n 1 -r
        echo
        if [[ "$REPLY" =~ ^[Yy]$ ]]; then
          cp -r --no-preserve=mode "${self}" "$flake"
        else
          git clone https://github.com/caio86/nixos "$flake"
        fi
      fi

      bootstrap_kit=$(mktemp -d)
      ssh_dir="/root/.ssh"
      clean_up_keys() {
        rm -rf "$bootstrap_kit"
        rm -rf "$ssh_dir"
      }
      add_exit_trap clean_up_keys

      echo "### Decrypting bootstrap-kit ###"
      bootstrap-kit decrypt "$bootstrap_kit"

      rm -rf "$ssh_dir"
      mkdir -p "$ssh_dir"
      cp "$bootstrap_kit/vega/caiol/id_ed25519" "$ssh_dir"
      cp "$bootstrap_kit/vega/caiol/id_ed25519.pub" "$ssh_dir"

      echo "### Fetching host information ###"
      host_config="$flake#nixosConfigurations.$hostname.config"
      username=$(nix eval --raw "$host_config.${ns}.core.username")
      admin_username=$(nix eval --raw "$host_config.${ns}.core.adminUsername")
      has_disko=$(nix eval --impure --expr "(builtins.getFlake \"$flake\").nixosConfigurations.$hostname.config.disko.devices.disk or {} != {}")

      echo "host_config = $host_config"
      echo "username = $username"
      echo "admin_username = $admin_username"
      echo "has_disko = $has_disko"

      if [ "$has_disko" = "false" ]; then
          echo "The host does not have a disko config"
          echo "You'll need to manually formatted and partitioned the disk then mounted it to /mnt";
          read -p "Have you done this? (y/N): " -n 1 -r
          echo
        if [[ ! "$REPLY" =~ ^[yY]$ ]]; then
          echo "Aborting" >&2
          exit 1
        fi
      fi

      rootDir="/mnt"

      read -p "Enter the address of a remote build host (leave empty to build locally): " -n 1 -r build_host
      if [ -z "$build_host" ]; then
        build_host=""
      else
        if ! nix store ping --store "ssh://$build_host" &> /dev/null; then
          echo "Error: build host $build_host cannot be pinged, aborting" >&2
          exit 1
        fi
      fi

      if [ "$has_disko" = "true" ]; then
        echo "WARNING: All data on the drive specified in the disko config of host '$hostname' will be destroyed"
        read -p "Are you sure you want to proceed? (y/N): " -n 1 -r
        echo
        if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
          echo "Aborting" >&2
          exit 1
        fi
      fi

      install_keys() {
        echo "### Installing keys ###"
        install -d -m755 "$rootDir/etc/ssh" "$rootDir/home"
        install -d -m700 "$rootDir/home/$username" "$rootDir/home/$admin_username"
        install -d -m700 "$rootDir/home/$username/.ssh" "$rootDir/home/$admin_username/.ssh"

        # Host keys
        mv "$bootstrap_kit/$hostname/ssh_host_ed25519_key" "$rootDir/etc/ssh"
        mv "$bootstrap_kit/$hostname/ssh_host_ed25519_key.pub" "$rootDir/etc/ssh"

        # User keys
        if [ -d "$bootstrap_kit/$hostname/$username" ]; then
          mv "$bootstrap_kit/$hostname/$username"/* "$rootDir/home/$username/.ssh"
        fi

        # Admin user keys
        if [[ -d "$bootstrap_kit/$hostname/$admin_username" && "$username" != "$admin_username" ]]; then
          mv "$bootstrap_kit/$hostname/$admin_username"/* "$rootDir/home/$admin_username/.ssh"
        fi

        rm -rf "$bootstrap_kit"

        chown -R 1000:100 "$rootDir/home/$username"

        if [ "$username" != "$admin_username" ]; then
          chown -R 1:1 "$rootDir/home/$admin_username"
        fi
      }

      run_disko() {
        if [ "$has_disko" = "true" ]; then
          echo "### Running disko format and mount ###"
          disko --mode disko --flake "$flake#$hostname"
        fi
      }

      install_nixos() {
        echo "### Building system ###"
        # nix build uses a tmpdir for build files. We need to make sure
        # this is located in persistent storage on the mounted filesystem.
        nix_build_tmp="$(mktemp -d -p "$rootDir")"

        add_exit_trap "rm -rf $nix_build_tmp"
        nixos_system=$(
          TMPDIR="$nix_build_tmp" nix build \
            --store "/mnt" \
            --no-link \
            --print-out-paths \
            --extra-experimental-features "nix-command flakes" \
            "$flake#nixosConfigurations.\"$hostname\".config.system.build.toplevel"
        )


        echo "### Installing system ###"
        nixos-install \
          --root "/mnt" \
          --no-root-passwd \
          --no-channel-copy \
          --system "$nixos_system"
      }

      run_disko
      install_keys
      install_nixos
    '';
  };
in
{
  imports = [ "${modulesPath}/installer/${base}" ];

  config = {
    isoImage.compressImage = false;

    environment.systemPackages =
      (with pkgs; [
        self.inputs.nix-secrets.packages.${pkgs.system}.bootstrap-kit
        gitMinimal
        disko
        zellij
        bottom
        neovim
      ])
      ++ [ installScript ];

    nix.settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      warn-dirty = false;
    };

    zramSwap.enable = true;

    services.openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
      settings.KbdInteractiveAuthentication = false;

      knownHosts = {
        "github.com".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
        "gitlab.com".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf";
      };

    };

    users.users.root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO02TcigmdT4nw+YbSdPM0Irs8Lu9YgINYjzzodfmvaF caiol@vega"
    ];

    system.stateVersion = "24.05";
  };
}
