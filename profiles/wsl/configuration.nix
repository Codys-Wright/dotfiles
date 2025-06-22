{
  # adding a comment
  lib,
  pkgs,
  systemSettings,
  userSettings,
  ...
}: {
  imports = [
    ./wsl.nix
  ];

  # Use systemSettings and userSettings passed from flake
  networking.hostName = systemSettings.hostname;
  time.timeZone = systemSettings.timezone;

  # System state version
  system.stateVersion = "22.05";
}
