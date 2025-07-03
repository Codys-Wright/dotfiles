{ config, userSettings, pkgs, ... }:

{
  bind = [
    # General
    "SUPER, return, exec, ${userSettings.term}"
    "$mod, q, killactive"
    "SUPERSHIFT, e, exit"
    "SUPERSHIFT, l, exec, hyprlock"

    # Screen focus
    "SUPER, v, togglefloating"
    "SUPER, u, focusurgentorlast"
    "SUPER, tab, focuscurrentorlast"
    "SUPER, f, fullscreen"

    # Screen resize
    "SUPERCTRL, h, resizeactive, -20 0"
    "SUPERCTRL, l, resizeactive, 20 0"
    "SUPERCTRL, k, resizeactive, 0 -20"
    "SUPERCTRL, j, resizeactive, 0 20"

    # Workspaces
    "SUPER, 1, workspace, 1"
    "SUPER, 2, workspace, 2"
    "SUPER, 3, workspace, 3"
    "SUPER, 4, workspace, 4"
    "SUPER, 5, workspace, 5"
    "SUPER, 6, workspace, 6"
    "SUPER, 7, workspace, 7"
    "SUPER, 8, workspace, 8"
    "SUPER, 9, workspace, 9"
    "SUPER, 0, workspace, 10"

    # Move to workspaces
    "SUPERSHIFT, 1, movetoworkspace, 1"
    "SUPERSHIFT, 2, movetoworkspace, 2"
    "SUPERSHIFT, 3, movetoworkspace, 3"
    "SUPERSHIFT, 4, movetoworkspace, 4"
    "SUPERSHIFT, 5, movetoworkspace, 5"
    "SUPERSHIFT, 6, movetoworkspace, 6"
    "SUPERSHIFT, 7, movetoworkspace, 7"
    "SUPERSHIFT, 8, movetoworkspace, 8"
    "SUPERSHIFT, 9, movetoworkspace, 9"
    "SUPERSHIFT, 0, movetoworkspace, 10"

    # Navigation
    "SUPER, h, movefocus, l"
    "SUPER, l, movefocus, r"
    "SUPER, k, movefocus, u"
    "SUPER, j, movefocus, d"

    # Applications
    "SUPERALT, f, exec, ${userSettings.browser}"
    "SUPERALT, e, exec, ${userSettings.term} --hold -e yazi"
    "SUPERALT, o, exec, obsidian"
    "SUPER, r, exec, pkill fuzzel || fuzzel"
    "SUPERALT, n, exec, swaync-client -t -sw"

    # Clipboard
    "SUPERALT, v, exec, pkill fuzzel || cliphist list | fuzzel --no-fuzzy --dmenu | cliphist decode | wl-copy"

    # Screencapture
    "SUPER, s, exec, grim | wl-copy"
    "SUPERSHIFTALT, s, exec, grim -g \"$(slurp)\" - | swappy -f -"

    # System
    "SUPERALT, w, exec, pkill wlogout || wlogout"

    # Scroll through existing workspaces with SUPER + scroll
    "SUPER, mouse_down, workspace, e+1"
    "SUPER, mouse_up, workspace, e-1"

    # Volume control
    ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
    ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
    ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"

    # Brightness control
    ", XF86MonBrightnessUp, exec, brightnessctl set 10%+"
    ", XF86MonBrightnessDown, exec, brightnessctl set 10%-"
  ];

  bindm = [
    "$mod, mouse:272, movewindow"
    "$mod, mouse:273, resizewindow"
  ];
}