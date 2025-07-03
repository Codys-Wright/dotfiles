{ config, lib, pkgs, userSettings, ... }:

{
  imports = [
    ./reaper/reaper.nix
  ];

  # Enable Reaper
  programs.reaper.enable = true;
} 