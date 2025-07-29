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
        "wm" # Window managers (KDE Plasma + Hyprland)
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

  # KDE Plasma configuration is now handled by the unified wm/kdePlasma module

  # System packages are now handled by unified modules

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
