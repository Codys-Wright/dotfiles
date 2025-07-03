{ config, lib, pkgs, ... }:

{
  # Enable bolt service for Thunderbolt management
  services.hardware.bolt.enable = true;

  # CLI tools collection for system-wide use
  environment.systemPackages = with pkgs; [
    # Thunderbolt management
    bolt
    
    # System utilities
    pciutils  # lspci
    usbutils  # lsusb
    hwdata    # Hardware database
    
    # Network utilities
    networkmanager
    iw
    wpa_supplicant
    
    # Storage utilities
    smartmontools
    hdparm
    
    # Process and system monitoring
    htop
    iotop
    lsof
    
    # File utilities
    tree
    ripgrep
    fd
    bat
    eza
    
    # Archive utilities
    unzip
    zip
    p7zip
    
    # Text processing
    jq
    yq
    xmlstarlet
    
    # Development tools
    git
    vim
    nano
  ];
} 