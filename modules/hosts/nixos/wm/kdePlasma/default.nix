{
  lib,
  config,
  pkgs,
  ...
}:

lib.custom.mkUnifiedModule {
  #
  # ========== System Configuration ==========
  #
  systemConfig = {
    # Enable KDE Plasma 6 desktop environment
    services = {
      desktopManager.plasma6.enable = true;

      # XRDP for remote desktop access
      xrdp = {
        defaultWindowManager = "startplasma-x11";
        enable = true;
        openFirewall = true;
      };

      # X11 server configuration (enabled for XWayland support)
      xserver = {
        enable = true;
        xkb = {
          layout = "us";
          variant = "";
        };
      };

      # GNOME Keyring for credential storage
      gnome.gnome-keyring.enable = true;
    };

    # Essential KDE system packages
    environment.systemPackages = with pkgs; [
      # KDE Core Applications
      pkgs.unstable.kdePackages.discover # Software center
      pkgs.unstable.kdePackages.kcalc # Calculator
      pkgs.unstable.kdePackages.kcharselect # Character selector
      pkgs.unstable.kdePackages.kcolorchooser # Color picker
      pkgs.unstable.kdePackages.kate # Text editor
      pkgs.unstable.kdePackages.konsole # Terminal
      pkgs.unstable.kdePackages.dolphin # File manager
      pkgs.unstable.kdePackages.gwenview # Image viewer
      pkgs.unstable.kdePackages.spectacle # Screenshot tool

      # KDE System Tools
      pkgs.unstable.kdePackages.systemsettings # System settings
      pkgs.unstable.kdePackages.sddm-kcm # SDDM configuration module
      pkgs.unstable.kdePackages.plasma-systemmonitor # System monitor

      # Development Tools
      kdiff3 # Diff tool

      # Media
      haruna # Video player

      # System utilities
      hardinfo2 # System information
      xclip # Clipboard tool for X11
    ];

    # Qt theming
    environment.sessionVariables = {
      QT_QPA_PLATFORMTHEME = "kde";
    };
  };

  #
  # ========== User Configuration ==========
  #
  userConfig = {
    # User-level KDE packages
    home.packages = with pkgs; [
      # Additional KDE applications
      pkgs.unstable.kdePackages.okular # Document viewer
      pkgs.unstable.kdePackages.ark # Archive manager
      pkgs.unstable.kdePackages.filelight # Disk usage analyzer
      pkgs.unstable.kdePackages.krdc # Remote desktop client
      pkgs.unstable.kdePackages.krfb # Desktop sharing

      # Multimedia
      pkgs.unstable.kdePackages.elisa # Music player
      # kdePackages.kamoso # Camera application - disabled due to being broken

      # Productivity
      pkgs.unstable.kdePackages.korganizer # Calendar/organizer
      pkgs.unstable.kdePackages.kontact # PIM suite

      # Graphics
      pkgs.unstable.kdePackages.kolourpaint # Paint program

      # Network
      pkgs.unstable.kdePackages.kget # Download manager
    ];

    # KDE-specific configurations
    home.file = {
      # Custom KDE shortcuts or configurations can go here
      ".config/kdeglobals".text = ''
        [General]
        BrowserApplication=firefox.desktop
      '';
    };

    # XDG MIME associations for KDE
    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = [ "okular.desktop" ];
        "image/jpeg" = [ "gwenview.desktop" ];
        "image/png" = [ "gwenview.desktop" ];
        "image/gif" = [ "gwenview.desktop" ];
        "video/mp4" = [ "haruna.desktop" ];
        "video/mkv" = [ "haruna.desktop" ];
        "audio/mp3" = [ "elisa.desktop" ];
        "audio/flac" = [ "elisa.desktop" ];
        "text/plain" = [ "kate.desktop" ];
        "application/zip" = [ "ark.desktop" ];
        "application/x-tar" = [ "ark.desktop" ];
      };
    };

    # Desktop directories
    home.file = {
      "Desktop/.keep".text = "";
      "Documents/.keep".text = "";
      "Downloads/.keep".text = "";
      "Pictures/.keep".text = "";
      "Videos/.keep".text = "";
      "Music/.keep".text = "";
    };
  };
}
