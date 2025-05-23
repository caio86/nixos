{ pkgs, inputs, ... }:

{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    vimdiffAlias = true;
    defaultEditor = true;
    withNodeJs = true;
    withPython3 = true;

    extraPackages = with pkgs; [
      # EXTRAS
      gnumake
      fzf
      ripgrep
      fd
      unzip
      tree-sitter
      gcc

      # LSP
      lua-language-server
      nil

      # FORMATTERS
      nodePackages.prettier
      nixfmt-rfc-style
      shfmt
      stylua
    ];
  };

  xdg.configFile."nvim".source = inputs.neovim-config;

  home.sessionVariables = {
    NIX_NEOVIM = 1;
  };
}
