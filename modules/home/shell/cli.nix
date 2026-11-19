{ pkgs, ... }:
{
  programs.fzf.enable = true;
  programs.bat.enable = true;
  programs.eza.enable = true;

  home.packages = with pkgs; [
    # Basics
    fd
    ripgrep
    jq
    tree
    killall
    zip
    unzip
    tldr
    bottom
    lazygit
    ranger # file manager
    w3m # text based web browser

    # Secrets (nix-secrets repo)
    sops
    age
    ssh-to-age

    # Fun
    fastfetch
    disfetch
    onefetch
    starfetch
    cava
    lolcat
    cowsay
  ];
}
