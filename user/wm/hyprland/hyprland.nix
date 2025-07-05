{
  config,
  lib,
  pkgs,
  userSettings,
  ...
}:

{
  imports = [
    ./wlogout.nix
    ./hypridle.nix
    ./waybar.nix
  ];

  home.packages = with pkgs; [
    # inputs.hypridle.packages.${pkgs.stdenv.hostPlatform.system}.hypridle
    # inputs.hyprlock.packages.${pkgs.stdenv.hostPlatform.system}.hyprlock
    hyprlock
    hypridle
    swww
    wofi
    dunst
    wlogout
    waybar
    smile
    cliphist
    networkmanagerapplet
    (pkgs.writeShellScriptBin "clip-history" ''
      case $1 in
        d) cliphist list | wofi -S dmenu | cliphist delete
          ;;

        w) if [ `echo -e "Clear\nCancel" | wofi -S dmenu` == "Clear" ] ; then
            cliphist wipe
          fi
          ;;

        *) cliphist list | wofi -S dmenu | cliphist decode | wl-copy
      esac
    '')
    (pkgs.writeShellScriptBin "screenshot-ocr" ''
      imgname="/tmp/screenshot-ocr-$(date +%Y%m%d%H%M%S).png"
      txtname="/tmp/screenshot-ocr-$(date +%Y%m%d%H%M%S)"
      txtfname=$txtname.txt
      ${pkgs.sway-contrib.grimshot}/bin/grimshot save area $imgname;
      ${pkgs.tesseract}/bin/tesseract -l por $imgname $txtname;
      wl-copy -n < $txtfname
    '')
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    # package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # portalPackage =
    #   inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    xwayland.enable = true;
    systemd.enable = true;
    settings = {
      # --------------------------------------#
      # Monitor Settings                      #
      # --------------------------------------#

      monitor = ",preferred,auto,1";

      # --------------------------------------#
      # Auto exec                             #
      # --------------------------------------#

      exec-once = [
        "dunst"
        "hypridle"
        "swww init"
        "wl-paste --watch cliphist store"
        "waybar"
        "syncthing --no-browser"
        "nm-applet --indicator"
        "discord --start-minimized"
        "steam -silent"
      ];

      exec = [ "swww img ${config.stylix.image}" ];

      # --------------------------------------#
      # Variables                             #
      # --------------------------------------#

      "$terminal" = "${userSettings.term}";
      "$fileManager" = "nautilus";
      "$browser" = "${userSettings.browser}";
      "$menu" = "wofi -i --show drun";

      env = [
        "bitdepth,10"
        "QT_QPA_PLATFORM,wayland"
      ];

      # --------------------------------------#
      # Keyboard                              #
      # --------------------------------------#

      input = {
        kb_layout = "br";
        kb_variant = "";
        kb_model = "";
        kb_options = "";

        follow_mouse = "1";

        touchpad = {
          natural_scroll = "no";
        };

        sensitivity = "0";
      };

      # --------------------------------------#
      # Window                                #
      # --------------------------------------#

      general = {
        gaps_in = 10; # 5
        gaps_out = 14; # 20
        border_size = 3; # 2
        "col.active_border" = lib.mkForce "0xff${config.lib.stylix.colors.base0E}";
        "col.inactive_border" = lib.mkForce "0x33${config.lib.stylix.colors.base03}";

        layout = "dwindle";
      };

      cursor = {
        inactive_timeout = 15;
      };

      # --------------------------------------#
      # Decoration                            #
      # --------------------------------------#

      decoration = {
        rounding = 10;

        blur = {
          enabled = true;
          size = 6; # 3
          passes = 2; # 1
        };
        active_opacity = 1.0;
        inactive_opacity = 0.8;
        fullscreen_opacity = 1.0;

        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = lib.mkForce "0xee${config.lib.stylix.colors.base00}";
      };

      # --------------------------------------#
      # Layout                                #
      # --------------------------------------#

      dwindle = {
        # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
        pseudotile = true; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = true; # you probably want this
      };

      gestures = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        workspace_swipe = false;
      };

      misc = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        force_default_wallpaper = -1;
        # disable_hyprland_logo = false;
        disable_splash_rendering = false;
        key_press_enables_dpms = true;
        mouse_move_enables_dpms = true;
      };

      animations = {
        enabled = true;

        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      # --------------------------------------#
      # Keybindins                            #
      # --------------------------------------#

      # SUPER KEY
      "$mainMod" = "SUPER";

      bind = [
        "$mainMod, period, exec, smile"
        "$mainMod, Return, exec, $terminal"
        "$mainMod, Q, killactive"
        "$mainMod, C, exec, wl-copy $(${pkgs.hyprpicker}/bin/hyprpicker)"
        "$mainMod, D, exec, brave --app=https://excalidraw.com/"
        "$mainMod, E, exec, $fileManager"
        "$mainMod, T, toggleFloating,"
        "$mainMod SHIFT, T, workspaceopt, allfloat"
        "$mainMod, R, exec, $menu"
        "$mainMod, P, pseudo,"
        "$mainMod, J, togglesplit,"
        "$mainMod, G, togglegroup"
        "$mainMod, F, fullscreen"
        "$mainMod, B, exec, $browser"
        "$mainMod, L, exec, hyprlock"
        "$mainMod, DELETE, exec, wlogout"
        "$mainMod, V, exec, clip-history"
        "$mainMod CTRL, V, exec, clip-history w"
        "$mainMod CTRL, minus, exec, hyprctl keyword misc:cursor_zoom_factor 1"
        "$mainMod CTRL, equal, exec, hyprctl keyword misc:cursor_zoom_factor 1.5"
        "$mainMod CTRL, R, exec, killall .waybar-wrapped; waybar & disown"

        # Screenshots
        "$mainMod ALT SHIFT, S, exec, ${pkgs.sway-contrib.grimshot}/bin/grimshot copy area"
        "$mainMod ALT, S, exec, ${pkgs.sway-contrib.grimshot}/bin/grimshot copy active"
        "$mainMod CTRL ALT, S, exec, screenshot-ocr"

        # Change selected window
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"
        "ALT, TAB, cyclenext"
        "ALT, TAB, bringactivetotop"
        "ALTSHIFT, TAB, cyclenext, prev"
        "ALTSHIFT, TAB, bringactivetotop"

        # Workspaces
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"

        "$mainMod CTRL, down, workspace, empty"

        # Special Workspace
        "$mainMod, S, togglespecialworkspace"
        "$mainMod SHIFT, S, movetoworkspace, special"

        "$mainMod CTRL, RETURN, togglespecialworkspace, coding"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      windowrulev2 = [
        "suppressevent maximize, class:.*"
        "tile,class:^(Brave-browser)$"
        "float,class:^(pavucontrol)$"
        "float,class:^(PacketTracer)$, title:^(?!(Cisco Packet Tracer)$).*$"

        # Smart gaps
        "bordersize 0, floating:0, onworkspace:w[tv1]"
        "rounding 0, floating:0, onworkspace:w[tv1]"
        "bordersize 0, floating:0, onworkspace:f[1]"
        "rounding 0, floating:0, onworkspace:f[1]"

        # Calculator
        "float,class:^(org.gnome.Calculator)$"
        "size 22% 46%,class:^(org.gnome.Calculator)$"
        "move 39% 27%,class:^(org.gnome.Calculator)$"

        "workspace 5 silent, class:^(steam)$"

        "workspace 5, class:^(steam_app_.*)$"
        "fullscreen, class:^(steam_app_.*)$"
        "suppressevent maximize, class:^(steam_app_.*)$"
        "suppressevent fullscreen, class:^(steam_app_.*)$"
      ];

      workspace = [
        # Smart gaps
        "w[tv1], gapsout:0, gapsin:0"
        "f[1], gapsout:0, gapsin:0"

        "5, border:false, rounding:false"
      ];
    };
  };
}
