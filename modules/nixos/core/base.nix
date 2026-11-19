{ pkgs, hostname, ... }:
{
  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  programs.zsh.enable = true;

  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-curses;
    enableSSHSupport = true;
  };

  environment.defaultPackages = [ ];
  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    fd
    ripgrep
    tree
  ];
}
