{ pkgs, lib, ... }:
{
  # Import wayland config
  imports = [ ./wayland.nix
              ./pipewire.nix
              ./dbus.nix
              ./fonts.nix
            ];

  # Force Hyprland to use logind instead of seatd to avoid libseat errors
  environment.sessionVariables = {
    LIBSEAT_BACKEND = "logind";
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

  hardware = {
    opengl.enable = true;
    nvidia.modesetting.enable = true;
  };

  programs = {
    hyprland = {
      enable = true;
      xwayland = {
        enable = true;
      };
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
    };
  };

  services.xserver.excludePackages = [ pkgs.xterm ];

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    enableHidpi = true;
    theme = "chili";
    package = pkgs.kdePackages.sddm;
  };
}
