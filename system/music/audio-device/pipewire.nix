{ config, lib, pkgs, ... }:

{
  # Enable PipeWire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Install required packages
  environment.systemPackages = with pkgs; [
    qjackctl
    pipewire
    qpwgraph
  ];

  # Ensure PipeWire can start at boot
  systemd.user.services.pipewire = {
    description = "PipeWire Multimedia Service";
    wantedBy = [ "default.target" ];
    after = [ "network.target" "sound.target" ];
  };

  # Disable PulseAudio to prevent conflicts
  services.pulseaudio.enable = false;

  # Enable real-time scheduling capabilities
  security.rtkit.enable = true;
} 