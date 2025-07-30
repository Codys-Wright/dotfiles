# Universal Bootloader Configuration System
# Supports GRUB, rEFInd, systemd-boot with hierarchical menus and themes
{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.hostSpec.bootloader;

  # Import shared options and types
  bootloaderOptionsModule = import ./options.nix { inherit lib; };
  bootloaderTypes = bootloaderOptionsModule.bootloaderTypes;
  entryTypes = bootloaderOptionsModule.entryTypes;

in {
  # No options needed here - they're defined in host-spec.nix via options.nix

  config = lib.mkIf (cfg != null && cfg.enable) {
    # Import the specific bootloader implementation
    imports = [
      (./. + "/${cfg.primary.type}")
    ];

    # Set up the bootloader based on configuration
    assertions = [
      {
        assertion = cfg.primary.type != null;
        message = "bootloaderSpec.primary.type must be specified";
      }
      {
        assertion = cfg.entries != [];
        message = "bootloaderSpec.entries cannot be empty";
      }
      {
        assertion = cfg.primary.theme == null || helpers.themeExists cfg.primary.type cfg.primary.theme;
        message = "Primary theme '${cfg.primary.theme or ""}' does not exist for bootloader '${cfg.primary.type}'. Available themes are in: ${./. + "/${cfg.primary.type}/themes"}";
      }
      {
        assertion = lib.all (entry:
          if entry.type == "submenu" && entry.submenu != null && entry.submenu.theme != null
          then helpers.themeExists entry.submenu.bootloader entry.submenu.theme
          else true
        ) cfg.entries;
        message = "One or more submenu themes do not exist for their specified bootloaders. Check theme directories in each bootloader folder.";
      }
      {
        assertion = helpers.themeExists cfg.primary.type cfg.themes.fallback;
        message = "Fallback theme '${cfg.themes.fallback}' does not exist for bootloader '${cfg.primary.type}'. Please create: ${./. + "/${cfg.primary.type}/themes/${cfg.themes.fallback}"}";
      }
    ];

    # Export configuration for bootloader implementations
    bootloaderSpec.internal = {
      inherit (cfg) primary entries themes features;

      # Helper functions for bootloader implementations
      helpers = {
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

        # Validate all themes in configuration
        validateThemes =
          let
            # Check primary theme
            primaryThemeValid = helpers.themeExists cfg.primary.type cfg.primary.theme;

            # Check submenu themes
            submenuThemesValid = lib.all (entry:
              if entry.type == "submenu" && entry.submenu != null
              then helpers.themeExists entry.submenu.bootloader entry.submenu.theme
              else true
            ) cfg.entries;
          in primaryThemeValid && submenuThemesValid;
      };
    };
  };
}
