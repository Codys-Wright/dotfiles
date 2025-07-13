{ config, lib, pkgs, userSettings, ... }:

{
  imports = [
    ./reaper/reaper.nix
    ./plugins/neural-amp-modeler.nix
  ];

  # Enable Reaper
  programs.reaper.enable = true;
} 