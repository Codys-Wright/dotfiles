# VM Bootloader Configuration
# Demonstrates the Universal Bootloader System for development VM
#
# This configuration uses hostSpec.bootloader which is defined by the
# Universal Bootloader System module. The bootloader options are properly
# typed and validated, keeping the configuration organized under hostSpec
# while maintaining separation in a dedicated bootloader.nix file.

{
  config,
  ...
}:

{
  # Enable the Universal Bootloader System via hostSpec
  # Options are defined in modules/common/optional/bootloaders/default.nix
  hostSpec.bootloader = {
    enable = true;

    # Primary bootloader configuration - GRUB works well in VMs
    primary = {
      type = "grub"; # GRUB for maximum VM compatibility
      theme = "hyperfluent"; # Modern HyperFluent theme fetched from GitHub
      customName = "NixOS VM"; # Clear identification
      timeout = 8; # Reasonable timeout for development
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
          bootloader = "grub"; # GRUB for all menus
          theme = "hyperfluent"; # Use same theme
          entries = [ ]; # Auto-populated with generations
        };
      }

      # VM-specific: Direct access to UEFI firmware
      {
        name = "BIOS/Firmware Settings";
        type = "firmware";
        priority = 30;
        visible = true;
      }

      # Other options submenu - contains all additional tools
      {
        name = "Other";
        type = "submenu";
        priority = 40;
        submenu = {
          bootloader = "grub"; # GRUB for all menus
          theme = "hyperfluent"; # Use same theme
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
    ];

    # Advanced features - good for development VM
    features = {
      chainloading = true; # Enable for testing different bootloader configs
      memtest = false; # Disabled - handled manually in "Other" submenu
      recovery = false; # Disabled - handled manually in "Other" submenu

      generationsMenu = {
        enable = true; # Essential for NixOS development
        maxEntries = 15; # Reasonable number for development
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
      "quiet" # Clean boot output
      "splash" # Show splash screen
      "console=tty1" # Ensure console access
      "console=ttyS0,115200" # Serial console for VM debugging
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
