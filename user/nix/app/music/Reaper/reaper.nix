{ config, lib, pkgs, userSettings, ... }:

{
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
} 