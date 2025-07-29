{
  lib,
  pkgs,
  ...
}:

lib.custom.mkUnifiedModule {
  #
  # ========== System Configuration ==========
  #
  systemConfig = {
    # Import all window manager system configurations
    imports = lib.custom.importSystemModules {
      path = lib.custom.relativeToOptionalModules "wm";
      modules = [
        "hyprland"
        "kdePlasma"
      ];
    };

    # Common window manager system packages
    environment.systemPackages = with pkgs; [
      # Common utilities for all window managers
      xorg.xrandr # Display configuration
      arandr # GUI for xrandr

      # Font management
      fontconfig # Font configuration
    ];

    # Common services for window managers
    services = {
      # Enable D-Bus (required by most desktop environments)
      dbus.enable = true;

      # Enable location services
      geoclue2.enable = true;
    };

    # Common environment variables
    environment.sessionVariables = {
      # GTK theme settings
      GTK_THEME = lib.mkDefault "Adwaita-dark";
    };
  };

  #
  # ========== User Configuration ==========
  #
  userConfig = {
    # Import all window manager user configurations
    imports = lib.custom.importUserModules {
      path = lib.custom.relativeToOptionalModules "wm";
      modules = [
        "hyprland"
        "kdePlasma"
      ];
    };

    # Common user packages for window managers
    home.packages = with pkgs; [
      # Theme management
      lxappearance # GTK theme manager

      # Common utilities
      xdg-utils # XDG utilities

      # Notification tools
      libnotify # Send notifications
    ];

    # Common XDG configuration
    xdg = {
      enable = true;

      # Default applications (can be overridden by specific WMs)
      mimeApps = {
        enable = true;
        defaultApplications = {
          "x-scheme-handler/http" = [ "firefox.desktop" ];
          "x-scheme-handler/https" = [ "firefox.desktop" ];
          "text/html" = [ "firefox.desktop" ];
        };
      };
    };

    # Common session variables for window managers
    home.sessionVariables = {
      # Enable GTK applications to use dark theme
      GTK_THEME = "Adwaita-dark";
    };
  };
}
