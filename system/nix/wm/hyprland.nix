{ pkgs, lib, config, ... }:
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
    NIXOS_OZONE_WL = "1";
    # Official NVIDIA configuration from Hyprland Wiki
    LIBVA_DRIVER_NAME = "nvidia";
    XDG_SESSION_TYPE = "wayland";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    # Multi-GPU support (prioritize NVIDIA discrete, fallback to AMD integrated)
    WLR_DRM_DEVICES = "/dev/dri/card0:/dev/dri/card1";
    # NVIDIA-first rendering to avoid Mesa conflicts
    __NV_PRIME_RENDER_OFFLOAD = "0";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    # Disable explicit sync to prevent crashes
    AQ_MGPU_NO_EXPLICIT = "1";
    # Force NVIDIA rendering
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  hardware = {
    graphics = {
      enable = true;
      # Force use of stable Mesa to prevent libgallium crashes
      package = pkgs.mesa;
    };
    
    nvidia = {
      # Modesetting is required for Wayland
      modesetting.enable = true;
      
      # Use latest production drivers (for RTX 4080 support)
      package = config.boot.kernelPackages.nvidiaPackages.production;
      
      # Use open-source kernel modules (recommended for RTX 30/40 series)
      open = true;
      
      # Enable power management (experimental, may cause sleep/suspend issues)
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      
      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver)
      nvidiaSettings = true;
    };
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

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
