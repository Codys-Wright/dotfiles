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
        ",preferred,auto,1"
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
        col.active_border = "0xff" + config.lib.stylix.colors.base08 + " " + "0xff" + config.lib.stylix.colors.base09 + " " + "0xff" + config.lib.stylix.colors.base0A + " " + "0xff" + config.lib.stylix.colors.base0B + " " + "0xff" + config.lib.stylix.colors.base0C + " " + "0xff" + config.lib.stylix.colors.base0D + " " + "0xff" + config.lib.stylix.colors.base0E + " " + "0xff" + config.lib.stylix.colors.base0F + " " + "270deg";
        col.inactive_border = "0xaa" + config.lib.stylix.colors.base02;
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
        "GDK_PIXBUF_MODULE_FILE," + pkgs.librsvg + "/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache
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
        "hyprctl setcursor " + config.gtk.cursorTheme.name + " " + builtins.toString config.gtk.cursorTheme.size
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

