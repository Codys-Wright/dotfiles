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
    # Professional audio system requirements
    environment.systemPackages = with pkgs; [
      # Professional audio tools
      jack2 # JACK Audio Connection Kit
      qjackctl # JACK control interface
      a2jmidid # ALSA to JACK MIDI bridge
    ];

    # Lower latency kernel settings for music production
    boot.kernelParams = [
      "threadirqs" # Use threaded IRQs for better real-time performance
    ];

    # Add user to audio group for professional audio access
    users.groups.audio = { };
  };

  #
  # ========== User Configuration ==========
  #
  userConfig = {
    # Professional music production software
    home.packages = with pkgs; [
      # Digital Audio Workstations
      ardour # Professional DAW
      reaper # Commercial DAW (unfree)
      reaper-reapack-extension # Package manager for REAPER
      reaper-sws-extension # REAPER Plugin Extension
      bitwig-studio # Commercial DAW (unfree)

      # Audio editors
      audacity # Audio editor
      audacious # Audio player with plugins

      # Synthesis and composition
      # vcv-rack      # Modular synthesizer
      hydrogen # Drum machine

      # Audio analysis
      qpwgraph # PipeWire graph manager
      helvum # PipeWire patchbay

      # Music notation
      musescore # Music notation software

      # Audio plugins (LV2/VST)
      calf # Audio plugins
      # guitarix      # Guitar amp simulator

      # MIDI tools
      qsynth # SoundFont synthesizer
      fluidsynth # SoundFont synthesizer
    ];

    # Professional audio settings
    home.sessionVariables = {
      # Ensure JACK applications find the right audio system
      PIPEWIRE_LATENCY = "128/48000"; # Lower latency for production
    };

    # Professional audio file associations
    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "audio/x-wav" = [ "ardour.desktop" ];
        "audio/x-aiff" = [ "ardour.desktop" ];
        "application/x-ardour" = [ "ardour.desktop" ];
      };
    };
  };
}
