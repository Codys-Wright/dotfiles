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
      "$mainMod" = "SUPER";

      monitor = [
        # Left monitor (Acer XV271U M3)
        "DP-4,2560x1440@180,0x0,1"
        # Center monitor (AOC Q32G1WG4) - primary
        "DP-3,2560x1440@144,2560x0,1"
        # Right monitor (Acer XV271U M3)
        "DP-5,2560x1440@180,5120x0,1"
      ];

      xwayland = {
          force_zero_scaling = false;
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

      # Window rules defined directly
      windowrulev2 = [
        # ===== REAPER DAW RULES =====
        # Main Reaper window - let it manage itself naturally
        "workspace 1,class:^(REAPER)$"
        "opacity 1.0 override,class:^(REAPER)$"
        
        # Only float specific dialog windows, not all child windows
        "float,class:REAPER,title:^(Preferences)$"
        "float,class:REAPER,title:^(Project Settings)$"
        "float,class:REAPER,title:^(Render to file)$"
        "float,class:REAPER,title:^(Export)$"
        "float,class:REAPER,title:^(Save As)$"
        "float,class:REAPER,title:^(Open)$"
        
        # Move dialogs to cursor but don't force size
        "move cursor,class:REAPER,floating:1"
        
        # Performance optimization for main window only
        "noanim,class:^(REAPER)$,title:^(REAPER)$"
        
        # ===== AUDIO PRODUCTION APPLICATIONS =====
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
        
        # ===== WINE APPLICATIONS =====
        # Bottles (Wine application manager)
        "float,class:^(com.usebottles.bottles)$"
        "move cursor,class:^(com.usebottles.bottles)$"
        "size 1000 700,class:^(com.usebottles.bottles)$"
        "opacity 1.0 override,class:^(com.usebottles.bottles)$"
        "noanim,class:^(com.usebottles.bottles)$"
        
        # Wine applications (general) - less aggressive rules
        "float,class:^(wine)$"
        "move cursor,class:^(wine)$"
        "opacity 1.0 override,class:^(wine)$"
        
        # Wine dialogs - float but don't force size
        "float,class:^(wine),title:^(.*Setup.*)$"
        "float,class:^(wine),title:^(.*Install.*)$"
        "float,class:^(wine),title:^(.*Config.*)$"
        "move cursor,class:^(wine),floating:1"
        
        # ===== UTILITY APPLICATIONS =====
        # Calculator
        "float,class:^(calculator)$"
        "move cursor,class:^(calculator)$"
        "size 400 600,class:^(calculator)$"
        
        # File manager dialogs
        "float,class:^(thunar)$,title:^(Properties)$"
        "float,class:^(thunar)$,title:^(Rename)$"
        "move cursor,class:^(thunar),floating:1"
        
        # ===== BROWSER RULES =====
        # Picture-in-picture windows
        "float,class:^(firefox)$,title:^(Picture-in-Picture)$"
        "float,class:^(chromium)$,title:^(Picture-in-Picture)$"
        "move cursor,class:^(firefox),floating:1"
        "move cursor,class:^(chromium),floating:1"
        
        # ===== SYSTEM DIALOGS =====
        # Polkit authentication dialogs
        "float,class:^(polkit-gnome-authentication-agent-1)$"
        "move cursor,class:^(polkit-gnome-authentication-agent-1)$"
        
        # Notification center
        "float,class:^(swaync)$"
        "move cursor,class:^(swaync)$"
        
        # ===== GAMING =====
        # Steam
        "fullscreen,class:^(steam)$"
        "stayfocused,class:^(steam)$"
        
        # ===== DEVELOPMENT =====
        # IDE windows
        "workspace 12,class:^(code)$"
        "workspace 13,class:^(jetbrains-idea)$"
        "workspace 13,class:^(intellij-idea)$"
        "workspace 13,class:^(pycharm)$"
        "workspace 13,class:^(webstorm)$"
        
        # ===== COMMUNICATION =====
        # Discord
        "workspace 6,class:^(discord)$"
        "float,class:^(discord)$,title:^(Discord)$"
        
        # Slack
        "workspace 6,class:^(slack)$"
        
        # ===== MEDIA =====
        # Video players
        "fullscreen,class:^(mpv)$"
        "fullscreen,class:^(vlc)$"
        "stayfocused,class:^(mpv)$"
        "stayfocused,class:^(vlc)$"
        
        # ===== WORKSPACE ASSIGNMENTS =====
        # Left Monitor (DP-4 - Acer) - Workspaces 1-4
        "workspace 1,class:^(REAPER)$"
        "workspace 1,class:^(brave-browser)$"
        "workspace 2,class:^(Vivaldi-stable)$"
        "workspace 3,class:^(chromium-browser)$"
        "workspace 4,class:^(thunderbird)$"
        
        # Center Monitor (DP-3 - AOC) - Primary - Workspaces 5, 6, 11, 12, 13, 14
        "workspace 5,class:^(kitty)$"
        "workspace 5,class:^(alacritty)$"
        "workspace 5,class:^(foot)$"
        "workspace 6,class:^(REAPER)$"
        "workspace 11,class:^(davinci-resolve)$"
        "workspace 12,class:^(code)$"
        "workspace 13,class:^(cursor)$"
        "workspace 14,class:^(steam)$"
        "workspace 14,class:^(lutris)$"
        
        # Right Monitor (DP-5 - Acer) - Workspaces 7-10
        "workspace 7,class:^(zen-beta)$"
        "workspace 8,class:^(discord)$"
        "workspace 8,class:^(telegram)$"
        "workspace 8,class:^(signal)$"
        "workspace 8,class:^(zoom)$"
        "workspace 9,class:^(obs)$"
        "workspace 10,class:^(REAPER)$"
        
        # Special workspace for Obsidian
        "workspace special:obsidian,class:^(obsidian)$"
      ];

      # Workspace rules - assign workspaces to specific monitors
      workspace = [
        # Left Monitor (DP-4 - Acer) - Workspaces 1-4
        "1, monitor:DP-4"
        "2, monitor:DP-4"
        "3, monitor:DP-4"
        "4, monitor:DP-4"
        
        # Center Monitor (DP-3 - AOC) - Primary - Workspaces 5, 6, 13, 14
        "5, monitor:DP-3"
        "6, monitor:DP-3"
        "13, monitor:DP-3"
        "14, monitor:DP-3"
        
        # Right Monitor (DP-5 - Acer) - Workspaces 7-10
        "7, monitor:DP-5"
        "8, monitor:DP-5"
        "9, monitor:DP-5"
        "10, monitor:DP-5"
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

