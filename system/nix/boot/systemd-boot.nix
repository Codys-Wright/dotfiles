{ config, lib, pkgs, systemSettings, ... }:

{
  # systemd-boot Bootloader Configuration
  boot.loader = {
    # Disable GRUB
    grub.enable = false;
    
    # Enable systemd-boot
    systemd-boot = {
      enable = true;
      
      # Configuration options
      configurationLimit = 10;
      
      # Enable editor for boot options
      editor = true;
      
      # Enable memtest86+ for memory testing
      memtest86.enable = true;
    };
    
    # EFI configuration
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = systemSettings.bootMountPath;
    };
  };
  
  # Additional boot configuration
  boot = {
    # Kernel parameters
    kernelParams = [
      "quiet"
      "splash"
      "nvidia-drm.modeset=1"  # For NVIDIA GPUs
    ];
    
    # Initrd configuration
    initrd = {
      # Enable systemd in initrd for better boot experience
      systemd.enable = true;
      
      # Available kernel modules for initrd
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
    };
  };
} 