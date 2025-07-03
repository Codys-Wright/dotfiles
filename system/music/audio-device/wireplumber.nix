{ config, lib, pkgs, ... }:

{
  # WirePlumber configuration through PipeWire
  services.pipewire = {
    # Enable WirePlumber as the session manager
    wireplumber.enable = true;
    
    # Configure PipeWire context properties for audio production
    extraConfig.pipewire."context.properties" = {
      "default.clock.rate" = 48000;
      "default.clock.quantum" = 1024;
      "default.clock.min-quantum" = 32;
      "default.clock.max-quantum" = 8192;
    };

    # Enable JACK support modules
    extraConfig.pipewire."context.modules" = [
      {
        name = "libpipewire-module-protocol-native";
        args = {};
        flags = [ "ifexists" "nofail" ];
      }
      {
        name = "libpipewire-module-jack";
        args = {};
        flags = [ "ifexists" "nofail" ];
      }
    ];
  };

  # Configure ALSA properties through environment variables
  environment.variables = {
    # ALSA configuration for audio production
    ALSA_JACK_DEVICE = "false";
    ALSA_RESERVE = "true";
  };
}
