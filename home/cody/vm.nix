{ lib, ... }:
{
  imports = [
    common/core
    common/optional/browsers
    common/optional/comms
    common/optional/desktops
    common/optional/development
    common/optional/helper-scripts
    common/optional/media
    common/optional/tools
  ]
  ++ lib.custom.importUserModules {
    path = lib.custom.relativeToOptionalModules "";
    modules = [
      "audio" # Core audio system
      "audio/music" # Music-specific user configuration
      "audio/music/production" # Professional music production tools
      "coding" # Development tools, editors, and programming languages
      "gaming" # Gaming applications and tools
      "virtualization" # Docker, Podman, VM tools
      "wm" # Window managers (KDE Plasma + Hyprland user configs)
    ];
  };

  #
  # ========== VM Monitor Configuration ==========
  #
  # Basic monitor setup for VM environment
  monitors = [
    {
      name = "Virtual-1"; # Standard VM display name
      width = 2560;
      height = 1440;
      refreshRate = 60;
      x = 0;
      y = 0;
      primary = true; # Required for hyprland scripts
      workspace = "1";
    }
  ];
}
