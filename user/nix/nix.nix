{ config, pkgs, ... }:

{
  imports = [
    ./style/stylix.nix
    ./wm/hyprland/hyprland.nix
    # ./wm/input/nihongo.nix
  ];

  # Additional core user configurations can go here
  # These should be configurations that are needed in every profile
  # For example, basic user settings, core keybindings, etc.
} 