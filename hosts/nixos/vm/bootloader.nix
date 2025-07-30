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
      type = "grub";                    # GRUB for maximum VM compatibility
      theme = null;                     # Disabled when using chained themes
      customName = "NixOS VM";          # Clear identification
      timeout = 8;                      # Reasonable timeout for development

      # Enable chained Minecraft theme system!
      chainedTheme = {
        enable = true;
        mainTheme = "minegrub";                        # Minecraft main menu for first screen
        submenuTheme = "minegrub-world-selection";     # Minecraft world selection for boot options
        mainMenuEntries = [
          "Singleplayer"              # Main NixOS boot option
          "Multiplayer"               # Alternative boot entry
          "Minecraft Realms"          # Advanced options submenu
          "Options"                   # Settings/firmware access
        ];
      };
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

      # More Options submenu - contains all additional tools and settings
      {
        name = "More Options";
        type = "submenu";
        priority = 30;
        submenu = {
          bootloader = "grub"; # GRUB for all menus
          theme = "hyperfluent"; # Use same theme
          entries = [
            # BIOS/Firmware settings
            {
              name = "BIOS/Firmware Settings";
              type = "firmware";
              priority = 10;
            }
            # Recovery options for development
            {
              name = "NixOS Recovery Mode";
              type = "os";
              osType = "nixos";
              priority = 20;
            }
          ];
        };
      }
    ];

    # Advanced features - good for development VM
    features = {
      chainloading = true; # Enable for testing different bootloader configs
      memtest = false; # Disabled - not needed in VM
      recovery = false; # Disabled - handled manually in "Other" submenu

      generationsMenu = {
        enable = true; # Re-enabled - will appear as "NixOS - All configurations"
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
