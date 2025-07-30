# Universal Bootloader Configuration System
# Supports GRUB, rEFInd, systemd-boot with hierarchical menus and themes
{
  lib,
  config,
  pkgs,
  ...
}:

let
  # Import shared options and types
  bootloaderOptionsModule = import ./options.nix { inherit lib; };
  bootloaderTypes = bootloaderOptionsModule.bootloaderTypes;
  entryTypes = bootloaderOptionsModule.entryTypes;

  # Helper functions factory (to avoid circular dependency)
  mkHelpers = cfg: {
    # Generate menu entries sorted by priority
    sortedEntries = lib.sort (a: b: a.priority < b.priority)
      (lib.filter (entry: entry.visible) cfg.entries);

    # Get theme path for a bootloader type (bootloader-specific themes)
    getThemePath = bootloaderType: themeName:
      let
        themeDir = ./. + "/${bootloaderType}/themes";
        selectedTheme = if themeName != null then themeName else cfg.themes.fallback;
      in "${themeDir}/${selectedTheme}";

    # Check if theme exists for specific bootloader
    themeExists = bootloaderType: themeName:
      let
        themeDir = ./. + "/${bootloaderType}/themes";
        selectedTheme = if themeName != null then themeName else cfg.themes.fallback;
        themePath = "${themeDir}/${selectedTheme}";
      in builtins.pathExists themePath;

    # Generate submenu configurations
    generateSubmenus = entries:
      lib.filter (entry: entry.type == "submenu") entries;
  };

in {
  # Separate internal options to avoid circular dependency
  options.bootloaderConfig = lib.mkOption {
    type = lib.types.attrs;
    default = {};
    internal = true;
    description = "Internal bootloader configuration for implementations";
  };

  # Import all bootloader implementations (they will conditionally activate)
  imports = [
    ./grub
    ./rEFInd
    ./system-d
  ];

  config = lib.mkIf (config.hostSpec.bootloader != null && config.hostSpec.bootloader.enable) {
    # Export processed configuration for bootloader implementations
    bootloaderConfig = let
      cfg = config.hostSpec.bootloader;
      helpers = mkHelpers cfg;
    in {
      inherit (cfg) primary entries themes features;
      inherit helpers;
    };

    # Basic bootloader assertions
    assertions = [
      {
        assertion = config.hostSpec.bootloader.primary.type != null;
        message = "hostSpec.bootloader.primary.type must be specified";
      }
      {
        assertion = config.hostSpec.bootloader.entries != [];
        message = "hostSpec.bootloader.entries cannot be empty";
      }
    ];
  };
}
