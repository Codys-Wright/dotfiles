{
  lib,
  inputs,
  pkgs,
  config,
  ...
}:

lib.custom.mkUnifiedModule {
  #
  # ========== System Configuration ==========
  #
  systemConfig = {
    # Enable Hyprland window manager
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    # Wayland-specific services
    services = {
      # Display manager for Wayland
      greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "${pkgs.greetd.tuigreet}/bin/tuigreet --asterisks --time --time-format '%I:%M %p | %a • %h | %F' --cmd Hyprland";
            user = config.hostSpec.primaryUser;
          };
        };
      };
    };

    # Essential Wayland system packages
    environment.systemPackages = with pkgs; [
      # Hyprland ecosystem
      hyprland # The window manager
      hyprpaper # Wallpaper utility
      hypridle # Idle daemon
      hyprlock # Screen locker
      hyprpicker # Color picker

      # Wayland utilities
      wl-clipboard # Clipboard utilities
      wlr-randr # Display configuration
      wayland-utils # Wayland debugging tools

      # Rose Pine cursor theme
      inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default

      # Screenshot tools
      grim # Screenshot utility
      slurp # Screen area selection

      # Notification daemon
      mako # Lightweight notification daemon

      # Authentication agent
      polkit_gnome # Polkit authentication agent
    ];

    # Security and authentication
    security.polkit.enable = true;
    security.pam.services.hyprlock = { }; # Required for hyprlock

    # XDG portal configuration for Hyprland
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
      ];
    };

    # Environment variables for Wayland
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1"; # Enable Wayland for Electron apps
      MOZ_ENABLE_WAYLAND = "1"; # Enable Wayland for Firefox
    };
  };

  #
  # ========== User Configuration ==========
  #
  userConfig = {
    # Wayland-specific user packages
    home.packages = with pkgs; [
      # Application launchers
      wofi # Application launcher
      rofi-wayland # Alternative launcher

      # Status bars
      waybar # Highly customizable status bar

      # File managers
      xfce.thunar # Lightweight file manager

      # Terminal emulators optimized for Wayland
      foot # Fast Wayland terminal
      alacritty # Cross-platform terminal

      # Media control
      playerctl # Media player control
      pavucontrol # PulseAudio control

      # System monitoring
      htop # Process viewer
      btop # Resource monitor

      # Network tools
      networkmanagerapplet # Network manager GUI

      # Clipboard manager
      cliphist # Clipboard history

      # Theme tools
      nwg-look # GTK theme manager
      libsForQt5.qt5ct # Qt5 theme manager

      # Image viewers
      imv # Wayland image viewer

      # PDF viewers
      zathura # Lightweight document viewer
    ];

    # Hyprland configuration (basic fallback - user configs can override)
    wayland.windowManager.hyprland = {
      enable = lib.mkDefault true;
      settings = {
        # Basic configuration
        monitor = lib.mkDefault [
          ",preferred,auto,1" # Auto-configure monitors
        ];

        # Input configuration
        input = lib.mkDefault {
          kb_layout = "us";
          follow_mouse = 1;
          touchpad = {
            natural_scroll = true;
            disable_while_typing = true;
          };
        };

        # General settings
        general = lib.mkDefault {
          gaps_in = 5;
          gaps_out = 10;
          border_size = 2;
          "col.active_border" = "rgba(c4a7e7ee) rgba(f6c177ee) 45deg";
          "col.inactive_border" = "rgba(6e6a86aa)";
          layout = "dwindle";
        };

        # Decoration
        decoration = lib.mkDefault {
          rounding = 8;
          blur = {
            enabled = true;
            size = 8;
            passes = 1;
          };
          drop_shadow = true;
          shadow_range = 4;
          shadow_render_power = 3;
          "col.shadow" = "rgba(1a1a1aee)";
        };

        # Animations
        animations = lib.mkDefault {
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

        # Basic keybindings
        bind = lib.mkDefault [
          "SUPER, Return, exec, foot"
          "SUPER, Q, killactive"
          "SUPER, M, exit"
          "SUPER, E, exec, ${pkgs.xfce.thunar}/bin/thunar"
          "SUPER, V, togglefloating"
          "SUPER, R, exec, wofi --show drun"

          # Move focus
          "SUPER, H, movefocus, l"
          "SUPER, L, movefocus, r"
          "SUPER, K, movefocus, u"
          "SUPER, J, movefocus, d"

          # Switch workspaces
          "SUPER, 1, workspace, 1"
          "SUPER, 2, workspace, 2"
          "SUPER, 3, workspace, 3"
          "SUPER, 4, workspace, 4"
          "SUPER, 5, workspace, 5"

          # Move window to workspace
          "SUPER SHIFT, 1, movetoworkspace, 1"
          "SUPER SHIFT, 2, movetoworkspace, 2"
          "SUPER SHIFT, 3, movetoworkspace, 3"
          "SUPER SHIFT, 4, movetoworkspace, 4"
          "SUPER SHIFT, 5, movetoworkspace, 5"

          # Screenshots
          ", Print, exec, grim ~/Pictures/screenshot_$(date +%Y%m%d_%H%M%S).png"
          "SHIFT, Print, exec, grim -g \"$(slurp)\" ~/Pictures/screenshot_$(date +%Y%m%d_%H%M%S).png"
        ];

        # Mouse bindings
        bindm = lib.mkDefault [
          "SUPER, mouse:272, movewindow"
          "SUPER, mouse:273, resizewindow"
        ];

        # Startup applications
        exec-once = lib.mkDefault [
          "waybar"
          "mako"
          "hyprpaper"
          "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
        ];
      };
    };

    # Waybar configuration
    programs.waybar = {
      enable = lib.mkDefault true;
      settings = lib.mkDefault {
        mainBar = {
          layer = "top";
          position = "top";
          height = 30;
          modules-left = [ "hyprland/workspaces" ];
          modules-center = [ "hyprland/window" ];
          modules-right = [
            "network"
            "pulseaudio"
            "battery"
            "clock"
          ];

          clock = {
            format = "{:%H:%M}";
            format-alt = "{:%A, %B %d, %Y (%R)}";
            tooltip-format = "<tt><small>{calendar}</small></tt>";
          };

          battery = {
            format = "{capacity}% {icon}";
            format-icons = [
              ""
              ""
              ""
              ""
              ""
            ];
          };

          network = {
            format-wifi = "{essid} ({signalStrength}%) ";
            format-ethernet = "{ifname}: {ipaddr}/{cidr} ";
            format-disconnected = "Disconnected ⚠";
          };

          pulseaudio = {
            format = "{volume}% {icon}";
            format-bluetooth = "{volume}% {icon}";
            format-muted = "";
            format-icons = {
              headphone = "";
              hands-free = "";
              headset = "";
              phone = "";
              portable = "";
              car = "";
              default = [
                ""
                ""
              ];
            };
            on-click = "pavucontrol";
          };
        };
      };
    };

    # Mako notification daemon configuration
    services.mako = {
      enable = lib.mkDefault true;
      settings = lib.mkDefault {
        background-color = "#1f1d2e";
        border-color = "#c4a7e7";
        text-color = "#e0def4";
        border-radius = 8;
        border-size = 2;
        default-timeout = 5000;
      };
    };

    # XDG MIME associations for Hyprland/Wayland
    xdg.mimeApps = {
      enable = lib.mkDefault true;
      defaultApplications = lib.mkDefault {
        "image/jpeg" = [ "imv.desktop" ];
        "image/png" = [ "imv.desktop" ];
        "image/gif" = [ "imv.desktop" ];
        "application/pdf" = [ "zathura.desktop" ];
        "inode/directory" = [ "thunar.desktop" ];
      };
    };
  };
}
