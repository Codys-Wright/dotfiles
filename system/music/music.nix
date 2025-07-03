{ config, lib, pkgs, inputs, userSettings, ... }:

{
  imports = [
    ./musnix.nix
    ./audio-device/pipewire.nix
    ./audio-device/wireplumber.nix
  ];

  # Additional system-wide music configurations can go here
  # For example, audio device configurations, system-wide audio settings, etc.
}