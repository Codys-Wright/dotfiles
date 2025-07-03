{ config, lib, pkgs, userSettings, ... }:

let
  cfg = config.programs.reaper;
in
{
  options.programs.reaper = {
    enable = lib.mkEnableOption "Enable Reaper DAW";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # Reaper DAW
      reaper
      
      # Basic audio tools
      jack2
      pulseaudio
      alsa-utils
      
      # Audio file format support
      ffmpeg
      sox
      flac
      
      # Wrapper script to ensure X11 backend - this is the primary way to launch Reaper
      (writeScriptBin "reaper-x11" ''
        #!/bin/sh
        export GDK_BACKEND=x11
        export QT_QPA_PLATFORM=xcb
        export _JAVA_AWT_WM_NONREPARENTING=1
        exec ${reaper}/bin/reaper "$@"
      '')
    ];

    # Set environment variables for Reaper to use X11 backend
    home.sessionVariables = {
      # Set X11 backend globally for all applications
      "GDK_BACKEND" = "x11";
      "QT_QPA_PLATFORM" = "xcb";
      "_JAVA_AWT_WM_NONREPARENTING" = "1";
    };

    # Create shell aliases for reaper to use the wrapper
    programs.bash.shellAliases = {
      reaper = "reaper-x11";
    };

    programs.zsh.shellAliases = {
      reaper = "reaper-x11";
    };

    programs.fish.shellAliases = {
      reaper = "reaper-x11";
    };

    # Create desktop entry for Reaper
    xdg.desktopEntries.reaper = {
      name = "REAPER";
      genericName = "Digital Audio Workstation";
      comment = "Professional Digital Audio Workstation";
      exec = "reaper-x11";
      icon = "reaper";
      terminal = false;
      type = "Application";
      categories = ["AudioVideo" "Audio" "AudioVideoEditing"];
    };
  };
} 