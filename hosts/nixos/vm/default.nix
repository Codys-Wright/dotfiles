#############################################################
#
#  VM - Development Virtual Machine
#  NixOS running on VM for development and testing
#
###############################################################

{
  inputs,
  lib,
  config,
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
      # ========== Optional Configs ==========
      #
      "hosts/common/optional/services/openssh.nix"
      "hosts/common/optional/services/greetd.nix" # display manager
      "hosts/common/optional/services/openssh.nix" # allow remote SSH access
      "hosts/common/optional/services/printing.nix" # CUPS
      "hosts/common/optional/audio.nix" # pipewire and cli controls
      "hosts/common/optional/libvirt.nix" # vm tools
      "hosts/common/optional/gaming.nix" # steam, gamescope, gamemode, and related hardware
      "hosts/common/optional/hyprland.nix" # window manager
      "hosts/common/optional/scanning.nix" # SANE and simple-scan
      "hosts/common/optional/thunar.nix" # file manager
      "hosts/common/optional/vlc.nix" # media player
      "hosts/common/optional/wayland.nix" # wayland components and pkgs not available in home-manager
    ])
  ];

  #
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

  services.gnome.gnome-keyring.enable = true;

  services = {
    desktopManager.plasma6.enable = true;

    displayManager = {
      sddm.enable = true;
      autoLogin = {
        enable = true;
        user = config.hostSpec.primaryUser;
      };
    };

    xrdp = {
      defaultWindowManager = "startplasma-x11";
      enable = true;
      openFirewall = true;
    };

    xserver = {
      enable = true;

      xkb = {
        layout = "us";
        variant = "";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    # KDE
    kdePackages.discover # Optional: Install if you use Flatpak or fwupd firmware update sevice
    kdePackages.kcalc # Calculator
    kdePackages.kcharselect # Tool to select and copy special characters from all installed fonts
    kdePackages.kcolorchooser # A small utility to select a color
    kdePackages.kolourpaint # Easy-to-use paint program
    kdePackages.ksystemlog # KDE SystemLog Application
    kdePackages.sddm-kcm # Configuration module for SDDM
    kdiff3 # Compares and merges 2 or 3 files or directories
    hardinfo2 # System information and benchmarks for Linux systems
    haruna # Open source video player built with Qt/QML and libmpv
    xclip # Tool to access the X clipboard from a console application
  ];

  networking = {
    networkmanager.enable = true;
    enableIPv6 = false;
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    timeout = 3;
  };

  boot.initrd = {
    systemd.enable = true;
  };

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
