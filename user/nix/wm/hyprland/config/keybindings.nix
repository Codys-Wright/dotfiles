{ config, userSettings, pkgs, ... }:

[
  # General
  "bind = SUPER, return, exec, ${userSettings.term}"
  "bind = SUPERSHIFT, q, killactive"
  "bind = SUPERSHIFT, e, exit"
  "bind = SUPERSHIFT, l, exec, hyprlock"

  # Screen focus
  "bind = SUPER, v, togglefloating"
  "bind = SUPER, u, focusurgentorlast"
  "bind = SUPER, tab, focuscurrentorlast"
  "bind = SUPER, f, fullscreen"

  # Screen resize
  "bind = SUPERCTRL, h, resizeactive, -20 0"
  "bind = SUPERCTRL, l, resizeactive, 20 0"
  "bind = SUPERCTRL, k, resizeactive, 0 -20"
  "bind = SUPERCTRL, j, resizeactive, 0 20"

  # Workspaces
  "bind = SUPER, 1, workspace, 1"
  "bind = SUPER, 2, workspace, 2"
  "bind = SUPER, 3, workspace, 3"
  "bind = SUPER, 4, workspace, 4"
  "bind = SUPER, 5, workspace, 5"
  "bind = SUPER, 6, workspace, 6"
  "bind = SUPER, 7, workspace, 7"
  "bind = SUPER, 8, workspace, 8"
  "bind = SUPER, 9, workspace, 9"
  "bind = SUPER, 0, workspace, 10"

  # Move to workspaces
  "bind = SUPERSHIFT, 1, movetoworkspace, 1"
  "bind = SUPERSHIFT, 2, movetoworkspace, 2"
  "bind = SUPERSHIFT, 3, movetoworkspace, 3"
  "bind = SUPERSHIFT, 4, movetoworkspace, 4"
  "bind = SUPERSHIFT, 5, movetoworkspace, 5"
  "bind = SUPERSHIFT, 6, movetoworkspace, 6"
  "bind = SUPERSHIFT, 7, movetoworkspace, 7"
  "bind = SUPERSHIFT, 8, movetoworkspace, 8"
  "bind = SUPERSHIFT, 9, movetoworkspace, 9"
  "bind = SUPERSHIFT, 0, movetoworkspace, 10"

  # Navigation
  "bind = SUPER, h, movefocus, l"
  "bind = SUPER, l, movefocus, r"
  "bind = SUPER, k, movefocus, u"
  "bind = SUPER, j, movefocus, d"

  # Applications
  "bind = SUPERALT, f, exec, ${userSettings.browser}"
  "bind = SUPERALT, e, exec, ${userSettings.term} --hold -e yazi"
  "bind = SUPERALT, o, exec, obsidian"
  "bind = SUPER, r, exec, pkill fuzzel || fuzzel"
  "bind = SUPERALT, n, exec, swaync-client -t -sw"

  # Clipboard
  "bind = SUPERALT, v, exec, pkill fuzzel || cliphist list | fuzzel --no-fuzzy --dmenu | cliphist decode | wl-copy"

  # Screencapture
  "bind = SUPER, s, exec, grim | wl-copy"
  "bind = SUPERSHIFTALT, s, exec, grim -g \"$(slurp)\" - | swappy -f -"

  # System
  "bind = SUPERALT, w, exec, pkill wlogout || wlogout"

  # Move/resize windows with mouse
  "bindm = SUPER, mouse:272, movewindow"
  "bindm = SUPER, mouse:273, resizewindow"

  # Scroll through existing workspaces with SUPER + scroll
  "bind = SUPER, mouse_down, workspace, e+1"
  "bind = SUPER, mouse_up, workspace, e-1"

  # Volume control
  "bind = , XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
  "bind = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
  "bind = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"

  # Brightness control
  "bind = , XF86MonBrightnessUp, exec, brightnessctl set 10%+"
  "bind = , XF86MonBrightnessDown, exec, brightnessctl set 10%-"
]