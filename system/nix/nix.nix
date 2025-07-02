{ config, pkgs, ... }:

{
  imports = [
    ./bin/phoenix.nix
    # ./boot/grub.nix
    # ./boot/systemd-boot.nix
    ./style/stylix.nix
    # ./wm/dbus.nix
    # ./wm/fonts.nix
    # ./wm/gnome-keyring.nix
    # ./wm/hyprland.nix
    # ./wm/pipewire.nix
    # ./wm/plasma.nix
    # ./wm/wayland.nix
    # ./wm/x11.nix
  ];

  # Additional core system configurations can go here
  # These should be configurations that are needed in every profile
} 