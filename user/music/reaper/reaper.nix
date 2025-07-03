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
    ];
  };
} 