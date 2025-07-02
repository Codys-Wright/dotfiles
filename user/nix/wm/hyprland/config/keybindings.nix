{ config, userSettings, ... }:

[
  # Window management
  "bind = SUPER, Q, killactive,"
  "bind = SUPER, M, exit,"
  "bind = SUPER, E, exec, ${userSettings.term}"
  "bind = SUPER, V, togglefloating,"
  "bind = SUPER, F, fullscreen,"
  "bind = SUPER, S, pseudo," # For pseudotiling

  # Application launching
  "bind = SUPER, R, exec, fuzzel" # Application launcher
  "bind = SUPER, W, exec, ${userSettings.spawnBrowser}" # Browser
  "bind = SUPER, C, exec, ${userSettings.spawnEditor}" # Editor

  # Focus and move
  "bind = SUPER, left, movefocus, l"
  "bind = SUPER, right, movefocus, r"
  "bind = SUPER, up, movefocus, u"
  "bind = SUPER, down, movefocus, d"

  "bind = SUPERSHIFT, left, movewindow, l"
  "bind = SUPERSHIFT, right, movewindow, r"
  "bind = SUPERSHIFT, up, movewindow, u"
  "bind = SUPERSHIFT, down, movewindow, d"

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

  # Scroll through existing workspaces with SUPER + scroll
  "bind = SUPER, mouse_down, workspace, e+1"
  "bind = SUPER, mouse_up, workspace, e-1"

  # Move/resize windows with mouse
  "bindm = SUPER, mouse:272, movewindow"
  "bindm = SUPER, mouse:273, resizewindow"

  # Screenshots
  "bind = SUPER, Print, exec, grimblast copy area"
  "bind = SHIFT, Print, exec, grimblast copy screen"

  # Volume control
  "bind = , XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise"
  "bind = , XF86AudioLowerVolume, exec, swayosd-client --output-volume lower"
  "bind = , XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"

  # Brightness control
  "bind = , XF86MonBrightnessUp, exec, swayosd-client --brightness raise"
  "bind = , XF86MonBrightnessDown, exec, swayosd-client --brightness lower"
]