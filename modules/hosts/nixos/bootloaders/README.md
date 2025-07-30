# Universal Bootloader Configuration System

A unified system for configuring GRUB, rEFInd, and systemd-boot with support for hierarchical menus, themes, and chainloading.

## 🚀 Features

- **Multi-Bootloader Support**: Configure GRUB, rEFInd, or systemd-boot
- **Hierarchical Menus**: Create submenus that can use different bootloaders or themes
- **Theme System**: Bootloader-specific themes with build-time validation
- **Chainloading**: Seamlessly switch between bootloaders for different menu levels
- **Type Safety**: Full validation of configurations at build time
- **Flexible Entry Types**: OS entries, submenus, generations, firmware settings

## 📁 Directory Structure

```
bootloaders/
├── default.nix              # Main configuration system
├── grub/
│   ├── default.nix         # GRUB implementation
│   └── themes/
│       ├── default/         # Default GRUB theme
│       ├── cyberpunk/       # Custom themes
│       └── minimal/
├── rEFInd/
│   ├── default.nix         # rEFInd implementation
│   └── themes/
│       ├── default/         # Default rEFInd theme
│       └── cyberpunk/
├── system-d/
│   ├── default.nix         # systemd-boot implementation
│   └── themes/
│       ├── default/         # Default systemd-boot theme
│       └── minimal/
└── example-usage.nix        # Complete usage examples
```

## 🔧 Basic Usage

### Simple Configuration

```nix
{
  hostSpec.bootloader = {
    enable = true;

    primary = {
      type = "grub";
      theme = "default";
      customName = "My NixOS";
      timeout = 10;
    };

    entries = [
      {
        name = "NixOS";
        type = "os";
        osType = "nixos";
        priority = 10;
      }
      {
        name = "Windows";
        type = "os";
        osType = "windows";
        priority = 20;
      }
    ];
  };
}
```

### Advanced Hierarchical Configuration

```nix
{
  hostSpec.bootloader = {
    enable = true;

    primary = {
      type = "grub";              # Primary bootloader
      theme = "cyberpunk";
      customName = "FastTrackStudio";
    };

    entries = [
      # Main OS
      {
        name = "FastTrackStudio \"Custom Name\"";
        type = "os";
        osType = "nixos";
        priority = 10;
      }

      # Submenu using different bootloader
      {
        name = "Other OS";
        type = "submenu";
        priority = 30;
        submenu = {
          bootloader = "rEFInd";    # Different bootloader for submenu
          theme = "default";
          entries = [
            {
              name = "Ubuntu";
              type = "os";
              osType = "linux";
              device = "/dev/nvme0n1p3";
            }
          ];
        };
      }

      # Generations submenu
      {
        name = "NixOS Generations";
        type = "submenu";
        priority = 40;
        submenu = {
          bootloader = "grub";
          theme = "minimal";        # Different theme
          entries = [];             # Auto-populated
        };
      }

      # Firmware settings
      {
        name = "BIOS/UEFI Settings";
        type = "firmware";
        priority = 50;
      }
    ];

    features = {
      chainloading = true;
      memtest = true;
      recovery = true;
      generationsMenu.enable = true;
    };
  };
}
```

## 🎨 Theme System

### Theme Structure

Each bootloader has its own theme format:

**GRUB Themes** (`grub/themes/*/theme.txt`):
```
desktop-color: "#2E3440"
menu-color-normal: "#D8DEE9"
menu-color-highlight: "#88C0D0"
+ boot_menu {
  left = 20%
  top = 20%
  width = 60%
  height = 60%
}
```

**rEFInd Themes** (`rEFInd/themes/*/theme.conf`):
```
banner background.png
selection_big selection_big.png
selection_small selection_small.png
icon_dir icons
font font.png
```

**systemd-boot Themes** (`system-d/themes/*/theme.conf`):
```
console-mode auto
timeout 10
kernel-params:
  quiet
  splash
```

### Creating Custom Themes

1. Create theme directory: `bootloaders/{bootloader}/themes/{theme-name}/`
2. Add theme configuration files (see examples above)
3. Add any required assets (backgrounds, icons, fonts)
4. Reference theme in configuration: `theme = "theme-name"`

## 🔗 Entry Types

### OS Entries
```nix
{
  name = "Windows";
  type = "os";
  osType = "windows";           # windows, nixos, linux, macos
  device = "/dev/nvme0n1p1";    # Optional device specification
  priority = 20;
}
```

### Submenu Entries (Hierarchical)
```nix
{
  name = "Advanced Options";
  type = "submenu";
  submenu = {
    bootloader = "rEFInd";      # Can use different bootloader
    theme = "minimal";          # Can use different theme
    entries = [
      # Nested entries...
    ];
  };
}
```

### Generations Menu
```nix
{
  name = "NixOS Generations";
  type = "generations";         # Auto-populated with system generations
}
```

### Firmware Settings
```nix
{
  name = "BIOS/UEFI Settings";
  type = "firmware";            # Direct firmware access
}
```

## ⚙️ Advanced Features

### Chainloading
Enables seamless switching between bootloaders:
```nix
features.chainloading = true;
```

### Memory Testing
Includes memtest86+ entries:
```nix
features.memtest = true;
```

### Recovery Options
Adds recovery mode entries:
```nix
features.recovery = true;
```

### Generations Menu
Dedicated NixOS generations management:
```nix
features.generationsMenu = {
  enable = true;
  maxEntries = 20;
};
```

## ✅ Build-Time Validation

The system validates configurations at build time:

- **Theme Existence**: Ensures specified themes exist for their bootloaders
- **Bootloader Compatibility**: Validates bootloader type combinations
- **Entry Structure**: Checks required fields for each entry type
- **Device Paths**: Validates device specifications (optional)

Example error messages:
```
error: Primary theme 'cyberpunk' does not exist for bootloader 'grub'.
Available themes are in: /nix/store/.../grub/themes

error: Fallback theme 'default' does not exist for bootloader 'rEFInd'.
Please create: /nix/store/.../rEFInd/themes/default
```

## 🔧 Implementation Details

### Bootloader Selection
The system automatically imports the correct bootloader implementation based on `primary.type`:
- `"grub"` → `grub/default.nix`
- `"rEFInd"` → `rEFInd/default.nix`
- `"systemd-boot"` → `system-d/default.nix`

### Theme Resolution
Themes are resolved using bootloader-specific paths:
```
{bootloader}/themes/{theme-name}/
```

### Chainloading Process
1. Primary bootloader loads with its theme
2. User selects submenu entry
3. System chainloads to specified bootloader
4. Secondary bootloader displays its entries with its theme

## 🎯 Use Cases

### Gaming Setup
- **Primary**: rEFInd (visual appeal)
- **Theme**: cyberpunk
- **Entries**: Gaming NixOS, Windows Gaming

### Server Setup
- **Primary**: systemd-boot (fastest boot)
- **Theme**: minimal
- **Entries**: Production, Recovery
- **Features**: No generations menu

### Development Setup
- **Primary**: GRUB (maximum flexibility)
- **Theme**: default
- **Entries**: Multiple Linux distros, Windows, macOS
- **Features**: Full generations menu, chainloading

## 🚨 Limitations

### systemd-boot
- Limited theme support (mainly console settings)
- No native submenu support (uses chainloading)
- Requires EFI system

### rEFInd
- No native nested menu support (uses manual entries)
- Requires EFI system
- Theme assets must be manually created

### GRUB
- More complex theme syntax
- Larger boot-time overhead
- Can work with both BIOS and EFI

## 🛠️ Troubleshooting

### Theme Not Found
```bash
# Check theme directory exists
ls modules/common/optional/bootloaders/grub/themes/

# Create missing theme
mkdir -p modules/common/optional/bootloaders/grub/themes/mytheme/
```

### Chainloading Issues
- Ensure `features.chainloading = true`
- Check EFI partition has enough space
- Verify secondary bootloader is properly installed

### Build Failures
- Check assertions in build output
- Validate theme names match directory names
- Ensure bootloader type is supported

## 📚 References

- [GRUB Manual](https://www.gnu.org/software/grub/manual/)
- [rEFInd Documentation](http://www.rodsbooks.com/refind/)
- [systemd-boot Documentation](https://www.freedesktop.org/wiki/Software/systemd/systemd-boot/)
- [NixOS Boot Process](https://nixos.org/manual/nixos/stable/index.html#sec-booting)
