# Bootloader Configurations

This directory contains modular bootloader configurations that can be imported into your main NixOS configuration.

## Available Bootloaders

### GRUB 2 (`grub.nix`)
- **Features**: Full-featured bootloader with menu, themes, and advanced options
- **Best for**: Users who want customization, dual-boot setups, or advanced boot options
- **Supports**: Both UEFI and BIOS systems
- **Includes**: OS prober for detecting other operating systems, memtest86+, cryptodisk support

### systemd-boot (`systemd-boot.nix`)
- **Features**: Simple, fast bootloader integrated with systemd
- **Best for**: Single-boot NixOS systems, minimal boot time
- **Supports**: UEFI systems only
- **Includes**: Built-in editor, memtest86+ support

## Usage

To use one of these bootloaders, import it in your profile configuration:

```nix
{ pkgs, lib, systemSettings, userSettings, inputs, ... }:

{
  imports = [
    ../../system/hardware-configuration.nix
    ../../system/boot/grub.nix  # or systemd-boot.nix
    # ... other imports
  ];
  
  # Remove any existing bootloader configuration from here
  # as it's now handled by the imported module
}
```

## Switching Bootloaders

To switch between bootloaders:

1. Change the import in your profile configuration
2. Rebuild the system: `sudo nixos-rebuild switch --flake .#system`
3. The new bootloader will be installed automatically

## Configuration

Both bootloader configurations use the `systemSettings` from your `flake.nix`:

- `bootMode`: "uefi" or "bios"
- `bootMountPath`: EFI mount point (usually "/boot")
- `grubDevice`: Device for GRUB installation (BIOS only)

## Customization

You can customize the bootloader configurations by:

1. Modifying the respective `.nix` file directly
2. Creating a new configuration that imports and overrides the base one
3. Adding bootloader-specific packages to your system packages

## Notes

- Only one bootloader should be enabled at a time
- GRUB 2 supports both UEFI and BIOS, while systemd-boot is UEFI-only
- The configurations include common kernel parameters and initrd settings
- Both configurations enable systemd in initrd for better boot experience 