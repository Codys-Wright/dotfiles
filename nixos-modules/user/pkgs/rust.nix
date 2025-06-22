{ config, lib, pkgs, ... }:

{
  imports = [
    # No additional imports needed
  ];

  options = {
    my.packages.rust.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Rust development package collection";
    };

    my.packages.rust.includeCargoTools = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Include additional Cargo tools and utilities";
    };
  };

  config = lib.mkIf config.my.packages.rust.enable {
    home.packages = with pkgs; [
      # Core Rust toolchain
      rustup
    ] ++ lib.optionals config.my.packages.rust.includeCargoTools [
      # Rust/Cargo utilities
      cargo-cache
      cargo-expand
    ];
  };
}