#############################################################
#
#  VM - Development Virtual Machine
#  NixOS running on VM for development and testing
#
###############################################################

{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = lib.flatten [
    #
    # ========== Hardware ==========
    #
    ./hardware-configuration.nix

    #
    # ========== Disk Layout ==========
    #
    inputs.disko.nixosModules.disko
    (lib.custom.relativeToRoot "hosts/common/disks/btrfs-disk.nix")
    {
      _module.args = {
        disk = "/dev/vda";
        withSwap = false;
      };
    }

    (map lib.custom.relativeToRoot [
      #
      # ========== Required Configs ==========
      #
      "hosts/common/core"

      #
      # ========== Bootloader ==========
      #
      "modules/common/optional/bootloaders" # Universal Bootloader System

      #
      # ========== Optional Configs ==========
      #
      "hosts/common/optional/services/openssh.nix"
      # greetd is provided by the Hyprland module
      "hosts/common/optional/services/openssh.nix" # allow remote SSH access
      "hosts/common/optional/services/printing.nix" # CUPS
      "hosts/common/optional/audio.nix" # pipewire and cli controls
      # libvirt is provided by the virtualization unified module
      "hosts/common/optional/scanning.nix" # SANE and simple-scan
      "hosts/common/optional/thunar.nix" # file manager
      "hosts/common/optional/vlc.nix" # media player
      "hosts/common/optional/wayland.nix" # wayland components and pkgs not available in home-manager

    ])

    #
    # ========== Host-Specific Bootloader ==========
    #
    ./bootloader.nix

    #
    # ========== Unified Modules (System) ==========
    #
    (lib.custom.importSystemModules {
      path = lib.custom.relativeToOptionalModules "";
      modules = [
        "audio" # Core audio system (pipewire, etc.)
        "audio/music" # Music-specific configuration
        "audio/music/production" # Professional music production tools
        "gaming" # Steam, GameMode, gaming tools
        "virtualization" # Docker, Podman, libvirt tools
        "wm/kdePlasma" # KDE Plasma only (not Hyprland)
      ];
    })
  ];

  # ========== Host Specification ==========
  #
  hostSpec = {
    hostName = "vm";

    # Primary user for system-level configurations
    primaryUser = "cody";

    # Multi-user configuration for this host
    users = {
      cody = {
        enable = true;
        isAdmin = true;
        extraGroups = [
          "wheel"
          "networkmanager"
          "audio"
          "video"
        ];
      };
    };
  };

  # Override greetd to use KDE Plasma instead of Hyprland
  services.greetd.settings = {
    default_session = {
      command = "${pkgs.greetd.tuigreet}/bin/tuigreet --asterisks --time --time-format '%I:%M %p | %a • %h | %F' --cmd startplasma-wayland";
      user = "cody";
    };
    
    initial_session = {
      command = "startplasma-wayland";
      user = "cody";
    };
  };

  # Disable SDDM from KDE module (conflicts with greetd)
  services.displayManager.sddm.enable = lib.mkForce false;
  services.displayManager.autoLogin.enable = lib.mkForce false;

  # Enable proper Wayland support for KDE Plasma
  services.desktopManager.plasma6.enableQt5Integration = true;
  
  # XDG portals for Wayland
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      kdePackages.xdg-desktop-portal-kde
      xdg-desktop-portal-gtk
    ];
  };

  # Environment variables for KDE Plasma Wayland
  environment.sessionVariables = {
    # KDE Wayland
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    
    # General Wayland
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
    
    # XDG
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "KDE";
  };

  # Ensure necessary packages for Wayland
  environment.systemPackages = with pkgs; [
    kdePackages.plasma-wayland-protocols
    wayland
    wayland-utils
  ];

  # KDE Plasma configuration is now handled by the unified wm/kdePlasma module

  # System packages are now handled by unified modules

  networking = {
    networkmanager.enable = true;
    enableIPv6 = false;
  };

  # Bootloader configuration moved to ./bootloader.nix
  # Uses Universal Bootloader System with GRUB

  boot.initrd = {
    systemd.enable = true;
  };

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
