# VM Bootloader Configuration
# Demonstrates the Universal Bootloader System for development VM
#
# This configuration uses hostSpec.bootloader which is defined by the
# Universal Bootloader System module. The bootloader options are properly
# typed and validated, keeping the configuration organized under hostSpec
# while maintaining separation in a dedicated bootloader.nix file.

{
  config,
  lib,
  ...
}:

{
  # Enable the Universal Bootloader System via hostSpec
  # Options are defined in modules/common/optional/bootloaders/default.nix
  hostSpec.bootloader = {
    enable = true;

    # Primary bootloader configuration - GRUB works well in VMs
    primary = {
      type = "grub";                    # GRUB for maximum VM compatibility
      theme = "default";                # Clean, readable theme for development
      customName = "NixOS VM";          # Clear identification
      timeout = 8;                      # Reasonable timeout for development
    };

    # Menu entries configuration
    entries = [
      # Main NixOS entry (highest priority)
      {
        name = "NixOS VM (Development)";
        type = "os";
        osType = "nixos";
        priority = 10;
        visible = true;
      }

      # NixOS Generations submenu - useful for development/testing
      {
        name = "NixOS Generations";
        type = "submenu";
        priority = 20;
        submenu = {
          bootloader = "grub";          # GRUB for all menus
          theme = "default";            # Default theme as requested
          entries = [];                 # Auto-populated with generations
        };
      }

      # Advanced Options submenu - demonstrates hierarchical menu
      {
        name = "Advanced Options";
        type = "submenu";
        priority = 30;
        submenu = {
          bootloader = "grub";          # GRUB for all menus
          theme = "default";            # Default theme as requested
          entries = [
            # Recovery options for development
            {
              name = "NixOS Recovery Mode";
              type = "os";
              osType = "nixos";
              priority = 10;
            }
            # Memory test option
            {
              name = "Memory Test";
              type = "os";
              osType = "memtest";
              priority = 20;
            }
          ];
        };
      }

      # VM-specific: Direct access to UEFI firmware (useful for VM testing)
      {
        name = "VM Firmware Settings";
        type = "firmware";
        priority = 40;
        visible = true;
      }
    ];

    # Advanced features - good for development VM
    features = {
      chainloading = true;              # Enable for testing different bootloader configs
      memtest = true;                   # Memory testing (useful for VM debugging)
      recovery = true;                  # Recovery options for development

      generationsMenu = {
        enable = true;                  # Essential for NixOS development
        maxEntries = 15;                # Reasonable number for development
      };
    };

    # Use default fallback theme
    themes = {
      fallback = "default";
    };
  };

  # VM-specific boot configuration (non-bootloader settings)
  boot = {
    # Enable boot logo for visual feedback
    plymouth.enable = true;

    # VM-friendly kernel parameters
    kernelParams = [
      "quiet"                           # Clean boot output
      "splash"                          # Show splash screen
      "console=tty1"                    # Ensure console access
      "console=ttyS0,115200"            # Serial console for VM debugging
    ];

    # Enable systemd in initrd for faster boot
    initrd.systemd.enable = true;

    # Note: boot.loader settings are managed by Universal Bootloader System
  };

  # Development-friendly assertions
  assertions = [
    {
      assertion = config.hostSpec.bootloader != null && config.hostSpec.bootloader.enable;
      message = "Universal Bootloader System must be enabled for VM";
    }
    {
      assertion = config.hostSpec.bootloader.primary.type == "grub";
      message = "VM should use GRUB for maximum compatibility";
    }
  ];
}
