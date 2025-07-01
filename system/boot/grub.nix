{ config, lib, pkgs, systemSettings, ... }:

{
  # GRUB 2 Bootloader Configuration
  boot.loader = {
    # Disable systemd-boot
    systemd-boot.enable = false;
    
    # Enable GRUB 2
    grub = {
      enable = true;
      version = 2;
      
      # For UEFI systems
      efiSupport = if (systemSettings.bootMode == "uefi") then true else false;
      efiInstallAsRemovable = if (systemSettings.bootMode == "uefi") then true else false;
      
      # For BIOS systems (fallback)
      device = if (systemSettings.bootMode == "bios") then systemSettings.grubDevice else null;
      
      # Use the latest kernel
      useOSProber = true;
      
      # Enable memtest86+ for memory testing
      enableCryptodisk = true;
      
      # Configuration options
      configurationLimit = 10;
      
      # Theme (optional - you can customize this)
      # theme = pkgs.grub2-themes;
      
      # Extra configuration
      extraConfig = ''
        # Set timeout to 5 seconds
        set timeout=5
        
        # Enable submenu for better organization
        set timeout_style=menu
        
        # Set default boot option (usually 0 for the first entry)
        set default=0
        
        # Enable serial console if needed
        # serial --unit=0 --speed=115200
        # terminal_input serial
        # terminal_output serial
      '';
      
      # Font configuration
      font = "${pkgs.dejavu_fonts}/share/fonts/truetype/DejaVuSans.ttf";
      fontSize = 16;
    };
    
    # EFI configuration (only for UEFI systems)
    efi = lib.mkIf (systemSettings.bootMode == "uefi") {
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