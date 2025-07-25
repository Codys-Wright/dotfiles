#NOTE: Actions prepended with `hy3;` are specific to the hy3 hyprland plugin
{
  config,
  lib,
  pkgs,
  ...
}:
{
  wayland.windowManager.hyprland.settings = {
    # Reference of supported bind flags: https://wiki.hyprland.org/Configuring/Binds/#bind-flags

    #
    # ========== Mouse Binds ==========
    #
    bindm = [
      # hold alt + leftlclick  to move/drag active window
      "ALT,mouse:272,movewindow"
      # hold alt + rightclick to resize active window
      "ALT,mouse:273,resizewindow"
    ];
    #
    # ========== Non-consuming Binds ==========
    #
    bindn = [
      # allow tab selection using mouse
      ", mouse:272, hy3:focustab, mouse"
    ];
    #
    # ========== Repeat Binds ==========
    #
    binde =
      let
        pactl = lib.getExe' pkgs.pulseaudio "pactl"; # installed via /hosts/common/optional/audio.nix
      in
      [
        # Resize active window 5 pixels in direction
        "Control_L&Shift_L&Alt_L, h, resizeactive, -5 0"
        "Control_L&Shift_L&Alt_L, j, resizeactive, 0 5"
        "Control_L&Shift_L&Alt_L, k, resizeactive, 0 -5"
        "Control_L&Shift_L&Alt_L, l, resizeactive, 5 0"

        #FIXME: repeat is not working for these
        # Volume - Output
        ", XF86AudioRaiseVolume, exec, ${pactl} set-sink-volume @DEFAULT_SINK@ +5%"
        ", XF86AudioLowerVolume, exec, ${pactl} set-sink-volume @DEFAULT_SINK@ -5%"
        # Volume - Input
        ", XF86AudioRaiseVolume, exec, ${pactl} set-source-volume @DEFAULT_SOURCE@ +5%"
        ", XF86AudioLowerVolume, exec, ${pactl} set-source-volume @DEFAULT_SOURCE@ -5%"
      ];
    #
    # ========== One-shot Binds ==========
    #
    bind =
      let
        workspaces = [
          "0"
          "1"
          "2"
          "3"
          "4"
          "5"
          "6"
          "7"
          "8"
          "9"
          "F1"
          "F2"
          "F3"
          "F4"
          "F5"
          "F6"
          "F7"
          "F8"
          "F9"
          "F10"
          "F11"
          "F12"
        ];
        # Map keys (arrows and hjkl) to hyprland directions (l, r, u, d)
        directions = rec {
          left = "l";
          right = "r";
          up = "u";
          down = "d";
          h = left;
          l = right;
          k = up;
          j = down;
        };
        pactl = lib.getExe' pkgs.pulseaudio "pactl"; # installed via /hosts/common/optional/audio.nix
        terminal = config.home.sessionVariables.TERM;
        editor = config.home.sessionVariables.EDITOR;
        #playerctl = lib.getExe pkgs.playerctl; # installed via /home/common/optional/desktops/playerctl.nix
        #swaylock = "lib.getExe pkgs.swaylock;
        #makoctl = "${config.services.mako.package}/bin/makoctl";
        #gtk-play = "${pkgs.libcanberra-gtk3}/bin/canberra-gtk-play";
        #notify-send = "${pkgs.libnotify}/bin/notify-send";
        #gtk-launch = "${pkgs.gtk3}/bin/gtk-launch";
        #xdg-mime = "${pkgs.xdg-utils}/bin/xdg-mime";
        #defaultApp = type: "${gtk-launch} $(${xdg-mime} query default ${type})";
        #browser = defaultApp "x-scheme-handler/https";

      in
      lib.flatten [

        #
        # ========== Quick Launch ==========
        #
        "ALT,space,exec,rofi -show drun"
        "SHIFT_ALT,space,exec,rofi -show run"
        "SUPER,s,exec,rofi -show ssh"
        "ALT,tab,exec,rofi -show window"

        "ALT,Return,exec,${terminal}"
        "CTRL_ALT,v,exec,${terminal} ${editor}"
        "CTRL_ALT,f,exec,thunar"

        #
        # ========== Screenshotting ==========
        #
        # TODO check on status of flameshot and multimonitor wayland. as of Oct 2024, it's a clusterfuck
        # so resorting to grimblast in the meantime
        #"CTRL_ALT,p,exec,flameshot gui"
        "CTRL_ALT,p,exec,grimblast --notify --freeze copy area"
        ",Print,exec,grimblast --notify --freeze copy area"

        #
        # ========== Media Controls ==========
        #
        # see "binde" above for volume ctrls that need repeat binding
        # Output
        ", XF86AudioMute, exec, ${pactl} set-sink-mute @DEFAULT_SINK@ toggle"
        # Input
        ", XF86AudioMute, exec, ${pactl} set-source-mute @DEFAULT_SOURCE@ toggle"
        # Player
        #FIXME For some reason these key pressings aren't firing from Moonlander. Nothing shows when running wev
        ", XF86AudioPlay, exec, 'playerctl --ignore-player=firefox,chromium,brave play-pause'"
        ", XF86AudioNext, exec, 'playerctl --ignore-player=firefox,chromium,brave next'"
        ", XF86AudioPrev, exec, 'playerctl --ignore-player=firefox,chromium,brave previous'"

        #
        # ========== Windows and Groups ==========
        #
        #NOTE: window resizing is under "Repeat Binds" above

        # Close the focused/active window
        "SHIFTALT,q,hy3:killactive"
        "SHIFTALT,q,killactive"

        # Fullscreen
        #"ALT,f,fullscreen,0" # 0 - fullscreen (takes your entire screen), 1 - maximize (keeps gaps and bar(s))
        "ALT,f,fullscreenstate,2 -1" # `internal client`, where `internal` and `client` can be -1 - current, 0 - none, 1 - maximize, 2 - fullscreen, 3 - maximize and fullscreen
        # Float
        "SHIFTALT,F,togglefloating"
        # Pin Active Floatting window
        "SHIFTALT, p, pin, active" # pins a floating window (i.e. show it on all workspaces)

        # Splits groups
        "ALT,v,hy3:makegroup,v" # make a vertical split
        "SHIFTALT,v,hy3:makegroup,h" # make a horizontal split
        "ALT,x,hy3:changegroup,opposite" # toggle btwn splits if untabbed
        "ALT,s,togglesplit"

        # Tab groups
        "ALT,g,hy3:changegroup,toggletab" # tab or untab the group
        #"ALT,t,lockactivegroup,toggle"
        "ALT,apostrophe,changegroupactive,f"
        "SHIFTALT,apostrophe,changegroupactive,b"

        #
        # ========== Workspaces ==========
        #
        # Change workspace
        (map (n: "ALT,${n},workspace,name:${n}") workspaces)

        # Special/scratch
        "ALT,y, togglespecialworkspace"
        "SHIFTALT,y,movetoworkspace,special"

        # Move window to workspace
        (map (n: "SHIFTALT,${n},hy3:movetoworkspace,name:${n}") workspaces)

        # Move focus from active window to window in specified direction
        #(lib.mapAttrsToList (key: direction: "ALT,${key}, exec, customMoveFocus ${direction}") directions)
        (lib.mapAttrsToList (key: direction: "ALT,${key},hy3:movefocus,${direction},warp") directions)

        # Move windows
        #(lib.mapAttrsToList (key: direction: "SHIFTALT,${key}, exec, customMoveWindow ${direction}") directions)
        (lib.mapAttrsToList (key: direction: "SHIFTALT,${key},hy3:movewindow,${direction}") directions)

        # Move workspace to monitor in specified direction
        (lib.mapAttrsToList (
          key: direction: "CTRLSHIFT,${key},movecurrentworkspacetomonitor,${direction}"
        ) directions)

        #
        # ========== Monitors==========
        #
        "SUPER, m, exec, toggleMonitors"
        "SUPER, n, exec, toggleMonitorsNonPrimary"

        #
        # ========== Misc ==========
        #
        "SHIFTALT,r,exec,hyprctl reload" # reload the configuration file
        "SUPER,l,exec,hyprlock" # lock the wm
        "SUPER,e,exec,wlogout" # lock the wm
      ];
  };
}
