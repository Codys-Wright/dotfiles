{ config, pkgs, ... }:

{
  imports = [
    ./docker.nix
    ./virtualization.nix
  ];

  # Additional system-level coding configurations can go here
  # For example, system-wide development tools, services, etc.
} 