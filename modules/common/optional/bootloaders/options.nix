# Universal Bootloader System - Options Definition
# This file defines the options that can be imported into hostSpec or other modules
{
  lib,
  ...
}:

let
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

in
{
  # Export the bootloader option definition for use in other modules
  bootloaderOptions = lib.mkOption {
    type = lib.types.nullOr (lib.types.submodule {
      options = {
        enable = lib.mkEnableOption "Universal bootloader configuration system";

        # Primary bootloader configuration
        primary = lib.mkOption {
          type = lib.types.submodule {
            options = {
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
          };
          default = {};
          description = "Primary bootloader configuration";
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
        themes = lib.mkOption {
          type = lib.types.submodule {
            options = {
              fallback = lib.mkOption {
                type = lib.types.str;
                default = "default";
                description = "Fallback theme name";
              };
            };
          };
          default = {};
          description = "Theme configuration";
        };

        # Advanced features
        features = lib.mkOption {
          type = lib.types.submodule {
            options = {
              chainloading = lib.mkEnableOption "Support for chainloading between bootloaders";
              memtest = lib.mkEnableOption "Include memtest86+ entry";
              recovery = lib.mkEnableOption "Include recovery options";

              generationsMenu = lib.mkOption {
                type = lib.types.submodule {
                  options = {
                    enable = lib.mkEnableOption "Separate generations menu";
                    maxEntries = lib.mkOption {
                      type = lib.types.int;
                      default = 20;
                      description = "Maximum number of generations to show";
                    };
                  };
                };
                default = {};
                description = "Generations menu configuration";
              };
            };
          };
          default = {};
          description = "Advanced bootloader features";
        };
      };
    });
    default = null;
    description = "Bootloader configuration for this host";
  };

  # Also export the types for use in implementation modules
  inherit bootloaderTypes entryTypes;
}
