# Universal Bootloader Configuration System
# Supports GRUB, rEFInd, systemd-boot with hierarchical menus and themes
{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.bootloaderSpec;

  # Bootloader type definitions
  bootloaderTypes = {
    grub = "grub";
    refind = "rEFInd";
    systemd = "systemd-boot";
  };

  # Menu entry types for hierarchical navigation
  entryTypes = {
    os = "os";           # Direct OS boot
    submenu = "submenu"; # Opens another bootloader/theme
    generations = "generations"; # NixOS generations menu
    firmware = "firmware";      # BIOS/UEFI settings
  };

in {
  options.bootloaderSpec = {
    enable = lib.mkEnableOption "Universal bootloader configuration system";

    # Primary bootloader configuration
    primary = {
      type = lib.mkOption {
        type = lib.types.enum (lib.attrValues bootloaderTypes);
        default = "grub";
        description = "Primary bootloader type";
      };

      theme = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Theme name for the primary bootloader";
      };

      customName = lib.mkOption {
        type = lib.types.str;
        default = "NixOS";
        description = "Custom display name for NixOS";
      };

      timeout = lib.mkOption {
        type = lib.types.int;
        default = 10;
        description = "Boot timeout in seconds";
      };
    };

    # Menu entries configuration
    entries = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options = {
          name = lib.mkOption {
            type = lib.types.str;
            description = "Display name for the menu entry";
          };

          type = lib.mkOption {
            type = lib.types.enum (lib.attrValues entryTypes);
            description = "Type of menu entry";
          };

          # For OS entries
          osType = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "OS type (windows, linux, macos, etc.)";
          };

          device = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "Device path for OS entries";
          };

          # For submenu entries (hierarchical navigation)
          submenu = lib.mkOption {
            type = lib.types.nullOr (lib.types.submodule {
              options = {
                bootloader = lib.mkOption {
                  type = lib.types.enum (lib.attrValues bootloaderTypes);
                  description = "Bootloader type for submenu";
                };

                theme = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  default = null;
                  description = "Theme for submenu bootloader";
                };

                entries = lib.mkOption {
                  type = lib.types.listOf lib.types.attrs;
                  default = [];
                  description = "Entries for submenu";
                };
              };
            });
            default = null;
            description = "Submenu configuration for hierarchical navigation";
          };

          # Entry ordering and visibility
          priority = lib.mkOption {
            type = lib.types.int;
            default = 100;
            description = "Entry priority (lower = higher in menu)";
          };

          visible = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Whether entry is visible in menu";
          };
        };
      });
      default = [];
      description = "Boot menu entries configuration";
    };

    # Theme configuration
    themes = {
      fallback = lib.mkOption {
        type = lib.types.str;
        default = "default";
        description = "Fallback theme name";
      };
    };

    # Advanced features
    features = {
      chainloading = lib.mkEnableOption "Support for chainloading between bootloaders";
      memtest = lib.mkEnableOption "Include memtest86+ entry";
      recovery = lib.mkEnableOption "Include recovery options";

      generationsMenu = {
        enable = lib.mkEnableOption "Separate generations menu";
        maxEntries = lib.mkOption {
          type = lib.types.int;
          default = 20;
          description = "Maximum number of generations to show";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
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
