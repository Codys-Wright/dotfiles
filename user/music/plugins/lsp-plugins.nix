{ config, lib, pkgs, userSettings, ... }:

{
  # Enable LSP Plugins
  home.packages = with pkgs; [
    lsp-plugins
  ];
} 