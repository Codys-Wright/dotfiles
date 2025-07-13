{ config, userSettings, pkgs, ... }:

{
  bind = [
    # General
    "$mainMod, return, exec, ${userSettings.term}"
    "$mainMod, q, killactive"
    "$mainMod SHIFT, e, exit"
    "$mainMod SHIFT, l, exec, hyprlock"

    # Screen focus
    "$mainMod, u, focusurgentorlast"
    "$mainMod, tab, focuscurrentorlast"
    "$mainMod, z, fullscreen"
    "$mainMod, f, togglefloating"

    # Screen resize
    "$mainMod CTRL, h, resizeactive, -20 0"
    "$mainMod CTRL, l, resizeactive, 20 0"
    "$mainMod CTRL, k, resizeactive, 0 -20"
    "$mainMod CTRL, j, resizeactive, 0 20"

    # ===== WORKSPACE KEYBINDINGS =====
    # Left Monitor (DP-4 - Acer) - Workspaces 1-4
    "$mainMod, 1, workspace, 1"
    "$mainMod, 2, workspace, 2"
    "$mainMod, 3, workspace, 3"
    "$mainMod, 4, workspace, 4"
    
    # Center Monitor (DP-3 - AOC) - Primary - Workspaces 5, 6, 13, 14
    "$mainMod, 5, workspace, 5"
    "$mainMod, 6, workspace, 6"
    "$mainMod, code:191, workspace, 13"
    "$mainMod, code:192, workspace, 14"
    
    # Right Monitor (DP-5 - Acer) - Workspaces 7-10
    "$mainMod, 7, workspace, 7"
    "$mainMod, 8, workspace, 8"
    "$mainMod, 9, workspace, 9"
    "$mainMod, 0, workspace, 10"

    # ===== MOVE TO WORKSPACES =====
    # Left Monitor (DP-4 - Acer) - Workspaces 1-4
    "$mainMod SHIFT, 1, movetoworkspace, 1"
    "$mainMod SHIFT, 2, movetoworkspace, 2"
    "$mainMod SHIFT, 3, movetoworkspace, 3"
    "$mainMod SHIFT, 4, movetoworkspace, 4"
    
    # Center Monitor (DP-3 - AOC) - Primary - Workspaces 5, 6, 13, 14
    "$mainMod SHIFT, 5, movetoworkspace, 5"
    "$mainMod SHIFT, 6, movetoworkspace, 6"
    "$mainMod SHIFT, code:191, movetoworkspace, 13"
    "$mainMod SHIFT, code:192, movetoworkspace, 14"
    
    # Right Monitor (DP-5 - Acer) - Workspaces 7-10
    "$mainMod SHIFT, 7, movetoworkspace, 7"
    "$mainMod SHIFT, 8, movetoworkspace, 8"
    "$mainMod SHIFT, 9, movetoworkspace, 9"
    "$mainMod SHIFT, 0 , movetoworkspace, 10"

    # Navigation
    "$mainMod, h, movefocus, l"
    "$mainMod, l, movefocus, r"
    "$mainMod, k, movefocus, u"
    "$mainMod, j, movefocus, d"
    
    # Multi-monitor navigation
    "$mainMod ALT, h, focusmonitor, l"
    "$mainMod ALT, l, focusmonitor, r"
    "$mainMod ALT, k, focusmonitor, u"
    "$mainMod ALT, j, focusmonitor, d"
    "$mainMod SHIFT ALT, h, movewindow, mon:l"
    "$mainMod SHIFT ALT, l, movewindow, mon:r"
    "$mainMod SHIFT ALT, k, movewindow, mon:u"
    "$mainMod SHIFT ALT, j, movewindow, mon:d"

    # Applications
    "$mainMod ALT, s, exec, ${userSettings.browser}"
    "$mainMod ALT, e, exec, ${userSettings.term} --hold -e yazi"
    "$mainMod ALT, o, exec, obsidian"
    "$mainMod, r, exec, pkill fuzzel || fuzzel"

    
    # Browser Workspaces
    "$mainMod, v, exec, hyprctl clients | grep -q brave-browser && hyprctl dispatch focuswindow class:brave-browser || brave"
    "$mainMod, a, exec, hyprctl clients | grep -q Vivaldi-stable && hyprctl dispatch focuswindow class:Vivaldi-stable || vivaldi"
    "$mainMod, p, exec, hyprctl clients | grep -q chromium-browser && hyprctl dispatch focuswindow class:chromium-browser || chromium"
    "$mainMod, s, exec, hyprctl clients | grep -q zen-beta && hyprctl dispatch focuswindow class:zen-beta || zen-browser"
    "$mainMod, n, exec, hyprctl clients | grep -q obsidian && hyprctl dispatch togglespecialworkspace obsidian || obsidian"

    # Reaper DAW controls
    "$mainMod ALT, r, exec, reaper"
    "$mainMod ALT, R, exec, hyprctl dispatch workspace 1"
    "$mainMod SHIFT, R, exec, hyprctl dispatch movetoworkspace 1"

    # Clipboard
    "$mainMod ALT, v, exec, pkill fuzzel || cliphist list | fuzzel --no-fuzzy --dmenu | cliphist decode | wl-copy"

    # Screencapture
    "$mainMod SHIFT, s, exec, grim | wl-copy"
    "$mainMod SHIFT ALT, s, exec, grim -g \"$(slurp)\" - | swappy -f -"

    # System
    "$mainMod ALT, w, exec, pkill wlogout || wlogout"

    # Scroll through existing workspaces with $mainMod + scroll
    "$mainMod, mouse_down, workspace, e+1"
    "$mainMod, mouse_up, workspace, e-1"

    # Volume control
    ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
    ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
    ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"

    # Brightness control
    ", XF86MonBrightnessUp, exec, brightnessctl set 10%+"
    ", XF86MonBrightnessDown, exec, brightnessctl set 10%-"
  ];

  bindm = [
    "$mainMod, mouse:272, movewindow"
    "$mainMod, mouse:273, resizewindow"
  ];
}