{ lib, config, pkgs, ... }:
let
  cfg = config.hypr;
in
{
  options.hypr = {
    enable = lib.mkEnableOption "enable hypr module";
  };
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      settings = {
        "$mod" = "SUPER";
        monitor = "eDP-1,1920x1080@60,1920x0,1";
        workspace = "eDP-1,1";
        "device:at-translated-set-2-keyboard" = {
          kb_layout = "it";
        };
        input = {
          kb_options = "compose:menu,level3:menu_switch";
          numlock_by_default = true;
          follow_mouse = 1;
          accel_profile = "flat";
          touchpad = {
            natural_scroll = true;
            scroll_factor = 0.3;
          };
        };
        general = {
          gaps_in = 5;
          gaps_out = 10;
          border_size = 2;
          "col.active_border" = "rgb(fabd2f) rgb(282828) 90deg";
          "col.inactive_border" = "rgb(282828)";
        };
        dwindle = {
          preserve_split = true;
          no_gaps_when_only = true;
        };
        decoration.inactive_opacity = 0.9;
        gestures.workspace_swipe = true;
        misc = {
          disable_hyprland_logo = true;
          disable_autoreload = true;
          # vrr = 1;
          vfr = true;
          animate_manual_resizes = true;
          animate_mouse_windowdragging = true;
        };
        bezier = [
          "overshot, 0.05, 0.9, 0.1, 1.1"
          "linear, 0, 0, 1, 1"
        ];
        animation = [
          "windows, 1, 5, overshot, slide"
          "workspaces, 1, 5, overshot"
          "borderangle, 1, 30, linear, loop"
        ];
        windowrule = [
          "float, popup"
          "float, wlogout"
          "float, Screenshare"
          "opacity 0.95, wlogout"
        ];
        windowrulev2 = [
          "opacity 0.0 override 0.0 override, class:^(xwaylandvideobridge)$"
          "noanim, class:^(xwaylandvideobridge)$"
          "nofocus, class:^(xwaylandvideobridge)$"
          "noinitialfocus, class:^(xwaylandvideobridge)$"
        ];
        bind = [
          "$mod, RETURN, exec, alacritty"
          "$mod, Q, killactive"
          "$mod, K, exit"
          "$mod, space, togglefloating"
          # "$mod, R, exec, ~/.local/bin/hyprgamemode r"
          "$mod, R, exec, hyprctl reload"
          "$mod_SHIFT, F, fakefullscreen"
          "$mod, F, fullscreen"
          "$mod, S, togglesplit"
          "$mod, G, togglegroup"
          "$mod, TAB, changegroupactive"
          "$mod, H, layoutmsg, preselect r"
          "$mod, V, layoutmsg, preselect d"
          "$mod_SHIFT, V, exec, ydotool type \"$(wl-paste)\""

          "$mod_SHIFT, left, movewindow, l"
          "$mod_SHIFT, right, movewindow, r"
          "$mod_SHIFT, up, movewindow, u"
          "$mod_SHIFT, down, movewindow, d"

          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"
          "$mod, 1, workspace, 1"
          "$mod, 2, workspace, 2"
          "$mod, 3, workspace, 3"
          "$mod, 4, workspace, 4"
          "$mod, 5, workspace, 5"
          "$mod, 6, workspace, 6"
          "$mod, 7, workspace, 7"
          "$mod, 8, workspace, 8"
          "$mod, 9, workspace, 9"
          "$mod, 0, workspace, 10"
          "$mod_ALT, h, togglespecialworkspace"

          "ALT, 1, movetoworkspace, 1"
          "ALT, 2, movetoworkspace, 2"
          "ALT, 3, movetoworkspace, 3"
          "ALT, 4, movetoworkspace, 4"
          "ALT, 5, movetoworkspace, 5"
          "ALT, 6, movetoworkspace, 6"
          "ALT, 7, movetoworkspace, 7"
          "ALT, 8, movetoworkspace, 8"
          "ALT, 9, movetoworkspace, 9"
          "ALT, 0, movetoworkspace, 10"
          "SHIFT_ALT, h, movetoworkspace, special"

          "$mod_SHIFT, 1, movetoworkspacesilent, 1"
          "$mod_SHIFT, 2, movetoworkspacesilent, 2"
          "$mod_SHIFT, 3, movetoworkspacesilent, 3"
          "$mod_SHIFT, 4, movetoworkspacesilent, 4"
          "$mod_SHIFT, 5, movetoworkspacesilent, 5"
          "$mod_SHIFT, 6, movetoworkspacesilent, 6"
          "$mod_SHIFT, 7, movetoworkspacesilent, 7"
          "$mod_SHIFT, 8, movetoworkspacesilent, 8"
          "$mod_SHIFT, 9, movetoworkspacesilent, 9"
          "$mod_SHIFT, 0, movetoworkspacesilent, 10"
          "$mod_SHIFT, h, movetoworkspacesilent, special"

          "$mod_ALT, right, swapactiveworkspaces, r"
          "$mod_ALT, left, swapactiveworkspaces, l"

          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_SINK@ toggle"
          "$mod, F4, exec, wpctl set-mute @DEFAULT_SOURCE@ toggle"
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioPause, exec, playerctl play-pause"
          ", XF86AudioNext, exec, playerctl next"
          ", XF86AudioPrev, exec, playerctl prev"
          ", XF86AudioStop, exec, playerctl stop"

          "$mod, L, exec, swaylock"
          "$mod, E, exec, wlogout"
          "$mod, N, exec, nautilus"
          "$mod, D, exec, rofi -show drun -theme ~/.config/rofi/themes/custom"
          "$mod, C, exec, rofi -show calc -modi calc -no-sort -theme gruvbox-dark"
          "$mod_SHIFT, E, exec, rofi -modi emoji -show emoji -theme gruvbox-dark"
          ", XF86Calculator, exec, rofi -show calc -modi calc -no-sort -theme gruvbox-dark"
          "$mod, I, exec, XDG_CURRENT_DESKTOP=gnome gnome-control-center"
          ", PRINT, exec, grimshot --notify save screen"
          "$mod_SHIFT, S, exec, grimshot --notify save area"
        ];
        binde = [
          "$mod, F5, exec, light -U 5"
          "$mod, F6, exec, light -A 5"
          ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_SINK@ 5%+"
          ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_SINK@ 5%-"
          "SHIFT, XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_SINK@ 1%+"
          "SHIFT, XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_SINK@ 1%-"
          "ALT, XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_SOURCE@ 5%+"
          "ALT, XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_SOURCE@ 5%-"
        ];
        bindl = [
          ", switch:[Switch Device at 67d953a0], exec, swaylock"
          ", sleep-button, exec, swaylock"
        ];
        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];
        exec = [
          "pkill waybar; waybar"
          "pkill hyprpaper; sleep 1; hyprpaper"
        ];
      };
    };
    xdg.configFile."hypr/hyprpaper.conf".text = ''
      preload=~/Pictures/wallpaper.jpg
      wallpaper=eDP-1,~/Pictures/wallpaper.jpg
      wallpaper=HDMI-A-1,~/Pictures/wallpaper.jpg
      wallpaper=HDMI-A-2,~/Pictures/wallpaper.jpg
      ipc = off
    '';
  };
}
