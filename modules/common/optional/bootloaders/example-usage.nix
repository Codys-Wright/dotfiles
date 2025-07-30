# Example Universal Bootloader Configuration
# This demonstrates the complete functionality you described

{
  config,
  lib,
  ...
}:

{
  # Enable the Universal Bootloader System via hostSpec
  hostSpec.bootloader = {
    enable = true;

    # Primary bootloader configuration
    primary = {
      type = "grub";                    # Primary bootloader: GRUB, rEFInd, or systemd-boot
      theme = "default";                # Theme name (must exist in grub/themes/)
      customName = "FastTrackStudio";   # Custom name for NixOS
      timeout = 10;                     # Boot timeout in seconds
    };

    # Menu entries configuration
    entries = [
      # Main NixOS entry (priority 10 = first)
      {
        name = "FastTrackStudio \"Custom Name for NixOS\"";
        type = "os";
        osType = "nixos";
        priority = 10;
      }

      # Windows entry
      {
        name = "Windows";
        type = "os";
        osType = "windows";
        device = "/dev/nvme0n1p1";  # Windows EFI partition
        priority = 20;
      }

      # Hierarchical "Other OS" submenu
      {
        name = "Other OS";
        type = "submenu";
        priority = 30;
        submenu = {
          bootloader = "rEFInd";        # Use rEFInd for this submenu
          theme = "default";            # rEFInd theme
          entries = [
            {
              name = "Ubuntu";
              type = "os";
              osType = "linux";
              device = "/dev/nvme0n1p3";
              priority = 10;
            }
            {
              name = "Arch Linux";
              type = "os";
              osType = "linux";
              device = "/dev/nvme0n1p4";
              priority = 20;
            }
            {
              name = "macOS";
              type = "os";
              osType = "macos";
              device = "/dev/nvme0n1p5";
              priority = 30;
            }
          ];
        };
      }

      # NixOS Generations submenu
      {
        name = "NixOS Generations";
        type = "submenu";
        priority = 40;
        submenu = {
          bootloader = "grub";          # Use GRUB for generations menu
          theme = "minimal";            # Different theme for generations
          entries = []; # Will be auto-populated with generations
        };
      }

      # BIOS/UEFI Settings
      {
        name = "BIOS/UEFI Settings";
        type = "firmware";
        priority = 50;
      }
    ];

    # Advanced features
    features = {
      chainloading = true;              # Enable chainloading between bootloaders
      memtest = true;                   # Include memtest86+ entry
      recovery = true;                  # Include recovery options

      generationsMenu = {
        enable = true;                  # Separate generations menu
        maxEntries = 20;                # Show last 20 generations
      };
    };
  };

  # Example of multiple bootloader configurations
  # You could define different configurations for different use cases:

  # Gaming-focused configuration
  # hostSpec.bootloader = {
  #   enable = true;
  #   primary.type = "rEFInd";         # rEFInd for visual appeal
  #   primary.theme = "cyberpunk";
  #   entries = [
  #     {
  #       name = "Gaming Mode";
  #       type = "os";
  #       osType = "nixos";
  #       priority = 10;
  #     }
  #     {
  #       name = "Windows Gaming";
  #       type = "os";
  #       osType = "windows";
  #       priority = 20;
  #     }
  #   ];
  # };

  # Server/minimal configuration
  # hostSpec.bootloader = {
  #   enable = true;
  #   primary.type = "systemd-boot";   # Fastest boot time
  #   primary.theme = "minimal";
  #   entries = [
  #     {
  #       name = "Production Server";
  #       type = "os";
  #       osType = "nixos";
  #       priority = 10;
  #     }
  #     {
  #       name = "Recovery Mode";
  #       type = "os";
  #       osType = "nixos";
  #       priority = 20;
  #     }
  #   ];
  #   features.generationsMenu.enable = false; # Don't need generations menu
  # };
}

# How this configuration works:
#
# 1. GRUB loads as the primary bootloader with the "default" theme
# 2. User sees menu with:
#    - FastTrackStudio "Custom Name for NixOS"
#    - Windows
#    - Other OS → (this opens rEFInd submenu)
#    - NixOS Generations → (this opens GRUB generations submenu)
#    - BIOS/UEFI Settings
#
# 3. If user selects "Other OS":
#    - System chainloads to rEFInd with the "default" rEFInd theme
#    - rEFInd shows: Ubuntu, Arch Linux, macOS options
#
# 4. If user selects "NixOS Generations":
#    - System opens GRUB submenu with "minimal" theme
#    - Shows last 20 NixOS generations
#
# 5. Build-time validation ensures:
#    - grub/themes/default/ exists
#    - grub/themes/minimal/ exists
#    - rEFInd/themes/default/ exists
#    - All specified bootloaders are available
#    - Device paths are valid (optional runtime check)
