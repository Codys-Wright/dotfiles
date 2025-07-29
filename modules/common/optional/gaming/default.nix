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
    # Hardware support for gaming
    hardware = {
      graphics.enable32Bit = true; # Required for 32-bit games
      xone.enable = true; # Xbox controller support
      # hardware.xpadneo.enable = true; # Alternative Xbox controller driver
    };

    # Gaming programs and services
    programs = {
      steam = {
        enable = true;
        protontricks = {
          enable = true;
          package = pkgs.protontricks;
        };
        package = pkgs.steam.override {
          extraPkgs =
            pkgs:
            (builtins.attrValues {
              inherit (pkgs.xorg)
                libXcursor
                libXi
                libXinerama
                libXScrnSaver
                ;

              inherit (pkgs.stdenv.cc.cc)
                lib
                ;

              inherit (pkgs)
                libpng
                libpulseaudio
                libvorbis
                libkrb5
                keyutils
                gperftools
                ;
            });
        };
        extraCompatPackages = [ pkgs.unstable.proton-ge-bin ];
      };

      # GameScope for improved gaming performance
      gamescope = {
        enable = true;
        capSysNice = true;
      };

      # GameMode for CPU/GPU optimization during gaming
      gamemode = {
        enable = true;
        settings = {
          general = {
            softrealtime = "on";
            inhibit_screensaver = 1;
          };
          gpu = {
            # apply_gpu_optimisations = "accept-responsibility";
            gpu_device = 1; # The DRM device number on the system (usually 0)
            amd_performance_level = "high";
          };
          custom = {
            start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
            end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
          };
        };
      };
    };

    # Gaming-related system packages
    environment.systemPackages = with pkgs; [
      # Game launchers
      lutris # Game launcher for various platforms
      heroic # Epic Games/GOG launcher
      bottles # Wine prefix manager

      # Game development
      godot_4 # Game engine

      # Utilities
      mangohud # Gaming overlay
      goverlay # MangoHud configuration GUI
    ];
  };

  #
  # ========== User Configuration ==========
  #
  userConfig = {
    # User-level gaming packages
    home.packages = with pkgs; [
      # Minecraft launchers
      prismlauncher # Minecraft launcher

      # Game streaming
      moonlight-qt # NVIDIA GameStream client

      # Game utilities
      gamemode # GameMode client tools

      # Discord for gaming communication
      discord

      # Game recording/streaming
      obs-studio
    ];

    # Gaming-related XDG associations
    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "application/x-ms-dos-executable" = [ "lutris.desktop" ];
      };
    };

    # Gaming directories
    home.file = {
      "Games/.keep".text = "";
      "Games/Steam/.keep".text = "";
      "Games/Lutris/.keep".text = "";
      "Games/Heroic/.keep".text = "";
    };
  };
}
