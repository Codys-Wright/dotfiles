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
    # Music-related system packages
    environment.systemPackages = with pkgs; [
      # Command line music tools
      mpd # Music Player Daemon
      mpc-cli # MPD client
    ];

    # Optional: Enable MPD system service
    # services.mpd = {
    #   enable = true;
    #   musicDirectory = "/home/music";
    # };
  };

  #
  # ========== User Configuration ==========
  #
  userConfig = {
    # Music player applications
    home.packages = with pkgs; [
      # GUI Music players
      spotify
      vlc
      mpv

      # Audio utilities
      easyeffects # Audio effects for PipeWire

      # Music management
      beets # Music library manager

      # Streaming
      youtube-music
    ];

    # XDG MIME associations for music files
    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "audio/mpeg" = [ "vlc.desktop" ];
        "audio/flac" = [ "vlc.desktop" ];
        "audio/wav" = [ "vlc.desktop" ];
        "audio/ogg" = [ "vlc.desktop" ];
        "audio/mp4" = [ "vlc.desktop" ];
        "audio/aac" = [ "vlc.desktop" ];
      };
    };

    # Music player daemon configuration (user-level)
    services.mpd = {
      enable = true;
      musicDirectory = "${config.home.homeDirectory}/Music";
      extraConfig = ''
        audio_output {
          type "pipewire"
          name "PipeWire Sound Server"
        }
      '';
    };
  };
}
