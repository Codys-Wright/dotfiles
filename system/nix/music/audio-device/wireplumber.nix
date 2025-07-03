{ config, lib, pkgs, ... }:

{
  services.wireplumber = {
    enable = true;
    # Default sample rate for audio processing
    extraConfig.pipewire."context.properties" = {
      "default.clock.rate" = 48000;
      "default.clock.quantum" = 1024;
      "default.clock.min-quantum" = 32;
      "default.clock.max-quantum" = 8192;
    };

    # Configure default nodes
    extraConfig.wireplumber."alsa.properties" = {
      "alsa.jack-device" = false;
      "alsa.reserve" = true;
    };

    # Enable JACK support
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
}
