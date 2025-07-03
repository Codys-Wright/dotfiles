{ config, lib, pkgs, userSettings, ... }:

{
  imports = [
    ./music/Reaper/reaper.nix
  ];

  # Enable Reaper
  programs.reaper.enable = true;
} 