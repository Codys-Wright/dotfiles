{ config, lib, pkgs, userSettings, ... }:

{
  imports = [
    ./reaper/reaper.nix
    ./plugins/neural-amp-modeler.nix
    ./plugins/lsp-plugins.nix
  ];

  # Enable Reaper
  programs.reaper.enable = true;
} 