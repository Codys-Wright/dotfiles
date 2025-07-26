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
    # Core audio system - use modern hardware.alsa instead of deprecated sound.enable
    hardware.pulseaudio.enable = false;

    # Base system packages for audio
    environment.systemPackages = with pkgs; [
      pavucontrol # PulseAudio volume control
      playerctl # Media player control
    ];

    # Pipewire configuration
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true; # Enable JACK for pro audio compatibility
    };

  };

  #
  # ========== User Configuration ==========
  #
  userConfig = {
    # Basic audio control tools
    home.packages = with pkgs; [
      pavucontrol
      playerctl
    ];

    # Enable playerctl daemon
    services.playerctld.enable = true;
  };
}
