{ config, lib, pkgs, userSettings, systemSettings, ... }:
{
  imports = [
    ./modules/waybar.nix
    ./modules/fuzzel.nix
    ./modules/hyprlock.nix
    ./modules/wlogout.nix
    ./modules/swaync.nix
  ];

  home.packages = with pkgs; [
    wl-clipboard
    slurp
    grim
    swappy
    cliphist
    brightnessctl
    hyprpaper
    polkit_gnome
    librsvg
  ];

  services.cliphist.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;

    settings = {
      "$terminal" = userSettings.term;
      "$mod" = "SUPER";

      monitor = [
        # Left monitor (Acer XV271U M3)
        "DP-4,2560x1440@180,0x0,1"
        # Center monitor (AOC Q32G1WG4) - primary
        "DP-3,2560x1440@144,2560x0,1"
        # Right monitor (Acer XV271U M3)
        "DP-5,2560x1440@180,5120x0,1"
      ];

      xwayland = {
        force_zero_scaling = true;
      };

      general = {
        gaps_in = 6;
        gaps_out = 6;
        border_size = 2;
        layout = "dwindle";
        allow_tearing = true;
        "col.active_border" = "0xff" + config.lib.stylix.colors.base08 + " 0xff" + config.lib.stylix.colors.base09 + " 0xff" + config.lib.stylix.colors.base0A + " 0xff" + config.lib.stylix.colors.base0B + " 0xff" + config.lib.stylix.colors.base0C + " 0xff" + config.lib.stylix.colors.base0D + " 0xff" + config.lib.stylix.colors.base0E + " 0xff" + config.lib.stylix.colors.base0F + " 270deg";
        "col.inactive_border" = "0xaa" + config.lib.stylix.colors.base02;
        resize_on_border = true;
      };

      input = {
        kb_layout = "us";
        follow_mouse = true;
        touchpad = {
          natural_scroll = true;
        };
        accel_profile = "flat";
        sensitivity = 0;
      };

      decoration = {
        rounding = 15;
        active_opacity = 0.9;
        inactive_opacity = 0.8;
        fullscreen_opacity = 0.9;
       

        blur = {
          enabled = true;
          xray = true;
          special = false;
          new_optimizations = true;
          size = 14;
          passes = 4;
          brightness = if (config.stylix.polarity == "dark") then 0.8 else 1.25;
          noise = 0.01;
          contrast = 1;
          popups = true;
          popups_ignorealpha = 0.6;
          ignore_opacity = false;
        };
      };

      animations = {
        enabled = true;
        bezier = [
          "linear, 0, 0, 1, 1"
          "md3_standard, 0.2, 0, 0, 1"
          "md3_decel, 0.05, 0.7, 0.1, 1"
          "md3_accel, 0.3, 0, 0.8, 0.15"
          "overshot, 0.05, 0.9, 0.1, 1.1"
          "crazyshot, 0.1, 1.5, 0.76, 0.92"
          "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
          "menu_decel, 0.1, 1, 0, 1"
          "menu_accel, 0.38, 0.04, 1, 0.07"
          "easeInOutCirc, 0.85, 0, 0.15, 1"
          "easeOutCirc, 0, 0.55, 0.45, 1"
          "easeOutExpo, 0.16, 1, 0.3, 1"
          "softAcDecel, 0.26, 0.26, 0.15, 1"
          "md2, 0.4, 0, 0.2, 1"
        ];
        animation = [
          "windows, 1, 3, md3_decel, popin 60%"
          "windowsIn, 1, 3, md3_decel, popin 60%"
          "windowsOut, 1, 3, md3_accel, popin 60%"
          "border, 1, 10, default"
          "fade, 1, 3, md3_decel"
          "layersIn, 1, 3, menu_decel, slide"
          "layersOut, 1, 1.6, menu_accel"
          "fadeLayersIn, 1, 2, menu_decel"
          "fadeLayersOut, 1, 4.5, menu_accel"
          "workspaces, 1, 7, menu_decel, slide"
          "specialWorkspace, 1, 3, md3_decel, slidevert"
        ];
      };

      cursor = {
        enable_hyprcursor = true;
        no_warps = false;
        inactive_timeout = 30;
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
        smart_split = false;
        smart_resizing = false;
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };

      # Comprehensive Reaper window rules based on Reddit recommendations
      windowrulev2 = [
        # Main Reaper window - fullscreen and stay focused
        # Only apply fullscreen to the main window, not popups
        "fullscreen,class:^(REAPER)$,title:^(REAPER)$"
        "stayfocused,class:^(REAPER)$,title:^(REAPER)$"
        "noanim,class:^(REAPER)$,title:^(REAPER)$"
        "opacity 1.0 override,class:^(REAPER)$,title:^(REAPER)$"
        
        # Child windows - floating and properly sized
        "float,class:REAPER,title:^(?!REAPER).*$"
        "move cursor,class:REAPER,floating:1"
        "size 800 600,class:REAPER,floating:1"
        "bordercolor rgb(00FF00),class:REAPER,floating:1"
        
        # Performance optimizations for child windows
        "noanim,class:REAPER,floating:1"
        "opacity 0.95 override,class:REAPER,floating:1"
        
        # Menu and popup handling - float but don't steal focus
        "float,class:REAPER,title:^(menu)$"
        "float,class:REAPER,title:^(.*popup.*)$"
        "float,class:REAPER,title:^(.*dialog.*)$"
        "float,class:REAPER,title:^(.*window.*)$"
        "nofocus,class:REAPER,title:^(menu)$"
        "nofocus,class:REAPER,title:^(.*popup.*)$"
        "nofocus,class:REAPER,title:^(.*dialog.*)$"
        "nofocus,class:REAPER,title:^(.*window.*)$"
        
        # Handle empty titles (tooltips, etc.)
        "float,class:REAPER,title:^$"
        "nofocus,class:REAPER,title:^$"
        
        # Border styling for different window types
        "bordercolor rgb(00AA00),class:REAPER,title:^(menu)$"
        "bordercolor rgb(008800),class:REAPER,title:^(.*popup.*)$"
        "bordercolor rgb(006600),class:REAPER,title:^(.*dialog.*)$"
        
        # Additional audio production applications
        # JACK Control
        "float,class:^(qjackctl)$"
        "move cursor,class:^(qjackctl)$"
        "size 400 300,class:^(qjackctl)$"
        
        # PulseAudio Volume Control
        "float,class:^(pavucontrol)$"
        "move cursor,class:^(pavucontrol)$"
        "size 500 400,class:^(pavucontrol)$"
        
        # ALSA Mixer
        "float,class:^(alsamixer)$"
        "move cursor,class:^(alsamixer)$"
        "size 600 400,class:^(alsamixer)$"
        
        # Carla (plugin host)
        "float,class:^(carla)$"
        "move cursor,class:^(carla)$"
        "size 800 600,class:^(carla)$"
        
        # Ardour (alternative DAW)
        "fullscreen,class:^(ardour)$"
        "stayfocused,class:^(ardour)$"
        "noanim,class:^(ardour)$"
      ];

      bind = (import ./config/keybindings.nix { inherit config userSettings pkgs; }).bind;
      
      bindm = (import ./config/keybindings.nix { inherit config userSettings pkgs; }).bindm;

      env = [
        "NIXOS_OZONE_WL,1"
        "_JAVA_AWT_WM_NONREPARENTING,1"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "QT_QPA_PLATFORM,wayland"
        "QT_QPA_PLATFORMTHEME,qt5ct"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "SDL_VIDEODRIVER,wayland"
        "GDK_BACKEND,wayland"
        "GDK_PIXBUF_MODULE_FILE,${pkgs.librsvg}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache"
        "LIBVA_DRIVER_NAME,nvidia"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "WLR_NO_HARDWARE_CURSORS,1"
        "WLR_RENDERER,vulkan"
        "MOZ_ENABLE_WAYLAND,1"
        "EGL_PLATFORM,wayland"
        "CLUTTER_BACKEND,wayland"
      ];

      exec-once = [
        "hyprpaper"
        "hyprctl setcursor ${config.gtk.cursorTheme.name} ${builtins.toString config.gtk.cursorTheme.size}"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        "eval $(gnome-keyring-daemon --start --components=secrets,ssh,gpg,pkcs11)"
        "dbus-update-activation-environment --systemd DISPLAY XAUTHORITY WAYLAND_DISPLAY XDG_SESSION_DESKTOP=Hyprland XDG_CURRENT_DESKTOP=Hyprland XDG_SESSION_TYPE=wayland"
        "hash dbus-update-activation-environment 2>/dev/null"
        "export SSH_AUTH_SOCK"
        "polkit-kde-authentication-agent-1"
      ];
    };
  };
}

