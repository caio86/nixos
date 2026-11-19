# nixos

NixOS + home-manager configuration for my machines (currently just `vega`).

## Layout

```
flake.nix            inputs, hosts and package outputs
lib/                 helpers exposed as lib.C410l.* (mkHost, scanPaths, ...)
hosts/
  vega/              desktop PC: default.nix (system), home.nix (user),
                     disko.nix (system disk), hardware-configuration.nix
  installer/         installer ISO with the `install-host` script
modules/
  nixos/             NixOS modules, all imported automatically
    core/            always on: nix settings, user, locale, sops, home-manager
    desktop/         C410l.desktop.plasma.enable, ...
    programs/        C410l.programs.{docker,gaming,virtualisation,wireshark}.enable
    services/        C410l.services.wireguard.<name>
  home/              home-manager modules, all imported automatically
    shell/ dev/ xdg  always on: zsh, cli tools, git, neovim, tmux
    apps/ dev/k8s    C410l.apps.{brave,kitty}.enable, C410l.dev.k8s.enable
pkgs/                own packages, available as pkgs.C410l.<name>
templates/           devshell templates (`dvt <name>` / `dvd <name>`)
```

Any `.nix` file placed under `modules/nixos` or `modules/home` is imported
automatically, so a new module only needs to declare an `enable` option and be
switched on in the host. User details (name, email, ...) are defined once in
`modules/nixos/core/users.nix` as `C410l.user.*`; home-manager modules read
them through `osConfig.C410l.user`.

Secrets come from the private `nix-secrets` flake input via sops-nix and are
decrypted with the host's SSH key.

## Usage

| Command                          | What it does                                     |
| -------------------------------- | ------------------------------------------------ |
| `rebuild-switch`                 | build and activate (`rebuild-test`, `-boot` too) |
| `rebuild-diff`                   | build and show package changes with nvd          |
| `inspect-host vega`              | open a `nix repl` with the host's config         |
| `dvt <template>`                 | `nix flake init` a devshell template             |
| `dvd <template>`                 | use a devshell template via direnv               |
| `nix build .#installer-x86_64`   | build the installer ISO                          |

## Notes

- vega runs with the firewall disabled and SSH password login allowed.
