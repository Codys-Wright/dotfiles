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

      # SDDM display manager configuration
      displayManager = {
        sddm.enable = true;
        autoLogin = {
          enable = true;
          user = config.hostSpec.primaryUser;
        };
      };

      # XRDP for remote desktop access
      xrdp = {
        defaultWindowManager = "startplasma-x11";
        enable = true;
        openFirewall = true;
      };

      # X11 server configuration
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
      kdePackages.discover # Software center
      kdePackages.kcalc # Calculator
      kdePackages.kcharselect # Character selector
      kdePackages.kcolorchooser # Color picker
      kdePackages.kate # Text editor
      kdePackages.konsole # Terminal
      kdePackages.dolphin # File manager
      kdePackages.gwenview # Image viewer
      kdePackages.spectacle # Screenshot tool

      # KDE System Tools
      kdePackages.systemsettings # System settings
      kdePackages.sddm-kcm # SDDM configuration module
      kdePackages.plasma-systemmonitor # System monitor

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
      kdePackages.okular # Document viewer
      kdePackages.ark # Archive manager
      kdePackages.filelight # Disk usage analyzer
      kdePackages.krdc # Remote desktop client
      kdePackages.krfb # Desktop sharing

      # Multimedia
      kdePackages.elisa # Music player
      kdePackages.kamoso # Camera application

      # Productivity
      kdePackages.korganizer # Calendar/organizer
      kdePackages.kontact # PIM suite

      # Graphics
      kdePackages.kolourpaint # Paint program

      # Network
      kdePackages.kget # Download manager
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
