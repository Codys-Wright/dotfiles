{ config, pkgs, lib, systemSettings, userSettings, ... }:

{
  # Enable the X11 windowing system
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment
  services.xserver.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    enableHidpi = true;
    theme = "chili";
    package = pkgs.kdePackages.sddm;
  };
  services.xserver.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents
  services.printing.enable = true;

  # Enable automatic login for the user (optional)
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = userSettings.username;

  # Add KDE-specific packages to user packages (optional)
  users.users.${userSettings.username}.packages = with pkgs; [
    kdePackages.kate
  ];
} 