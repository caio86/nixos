{ lib, config, ... }:
{
  options.C410l.apps.kitty.enable = lib.mkEnableOption "the kitty terminal";

  config = lib.mkIf config.C410l.apps.kitty.enable {
    programs.kitty = {
      enable = true;
      font = {
        name = "FiraCode Nerd Font";
        size = 10;
      };
      themeFile = "Catppuccin-Mocha";
      settings = {
        tab_bar_edge = "bottom";
        tab_bar_style = "powerline";
        tab_powerline_style = "slanted";
        tab_title_template = "{title}{' :{}:'.format(num_windows) if num_windows > 1 else ''}";
      };
    };
  };
}
