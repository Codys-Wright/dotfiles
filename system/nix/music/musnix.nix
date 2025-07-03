{ config, lib, pkgs, inputs, userSettings, ... }:

{
  imports = [ inputs.musnix.nixosModules.musnix ];

  # Enable musnix for real-time audio production
  musnix = {
    enable = true;
    
    # Enable ALSA sequencer for MIDI support
    alsaSeq.enable = true;
    
    # Enable rtcqs for audio system analysis
    rtcqs.enable = true;
    
    # Set soundcard PCI ID (you can find this with: lspci | grep -i audio)
    # soundcardPciId = "00:1b.0";  # Uncomment and set your soundcard ID
    
    # Enable FFADO for FireWire audio devices (optional)
    # ffado.enable = true;
  };

  # Additional audio-related system packages
  environment.systemPackages = with pkgs; [
    # Audio utilities
    alsa-utils
    pulseaudio
    jack2
    
    # Audio analysis tools
    snd
    audacity
    
    # MIDI tools
    timidity
    fluidsynth
    
    # Audio file format support
    ffmpeg
    sox
    flac
    vorbis-tools
    
    # Real-time audio tools
    ardour
    qtractor
    
    # Audio plugins
    calf
    lsp-plugins
    zam-plugins
  ];

  # Add user to audio group for real-time privileges
  users.users.${userSettings.username}.extraGroups = [ "audio" ];

  # Security settings for real-time audio
  security.pam.loginLimits = [
    {
      domain = "@audio";
      item = "memlock";
      type = "-";
      value = "unlimited";
    }
    {
      domain = "@audio";
      item = "rtprio";
      type = "-";
      value = "99";
    }
    {
      domain = "@audio";
      item = "nofile";
      type = "soft";
      value = "99999";
    }
    {
      domain = "@audio";
      item = "nofile";
      type = "hard";
      value = "99999";
    }
  ];
} 