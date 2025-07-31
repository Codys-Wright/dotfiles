{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkOption mkEnableOption types mkIf;

  cfg = config.custom.displayProtocol;
in
{
  options.custom.displayProtocol = {
    enable = mkEnableOption "custom display protocol configurations";

    type = mkOption {
      type = types.enum [ "wayland" "x11" "hybrid" ];
      default = "wayland";
      description = "Display protocol type to use";
    };

    desktop = mkOption {
      type = types.enum [ "plasma" "hyprland" "gnome" "sway" ];
      default = "plasma";
      description = "Desktop environment to use";
    };

    unstable = mkOption {
      type = types.bool;
      default = false;
      description = "Use unstable packages for display protocol";
    };
  };

  config = mkIf cfg.enable {
    # XDG Portal configuration
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        kdePackages.xdg-desktop-portal-kde
        xdg-desktop-portal-gtk
      ];
    };

    # Environment variables based on session type
    environment.sessionVariables = mkIf (cfg.type == "wayland") {
      # KDE Wayland
      QT_QPA_PLATFORM = "wayland;xcb";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

      # General Wayland
      MOZ_ENABLE_WAYLAND = "1";
      NIXOS_OZONE_WL = "1";

      # XDG
      XDG_SESSION_TYPE = "wayland";
      XDG_CURRENT_DESKTOP = lib.mkIf (cfg.desktop == "plasma") "KDE";
    };

    # System packages based on session type and desktop
    environment.systemPackages = with pkgs; mkIf (cfg.type == "wayland") [
      # Essential Wayland packages
      (if cfg.unstable then pkgs.unstable.wayland else wayland)
      (if cfg.unstable then pkgs.unstable.wayland-utils else wayland-utils)

      # Desktop-specific packages
      (lib.mkIf (cfg.desktop == "plasma") (
        if cfg.unstable then pkgs.unstable.kdePackages.plasma-wayland-protocols else kdePackages.plasma-wayland-protocols
      ))
    ];

    # X11 server configuration for hybrid mode
    services.xserver = mkIf (cfg.type == "hybrid" || cfg.type == "x11") {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
    };
  };
}