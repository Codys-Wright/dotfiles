{ config, pkgs, ... }:

{
  imports = [
    ./steam.nix
    ./gamemode.nix
    ./prismlauncher.nix
  ];

  # Additional system-level gaming configurations can go here
  # For example, gaming-specific kernel modules, services, etc.
} 