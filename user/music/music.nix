{ config, pkgs, ... }:

{
  imports = [
    # ./app/  # Uncomment when you add music applications
    # ./lang/  # Uncomment when you add music language tools
    # ./shell/  # Uncomment when you add music shell configs
    # ./pkgs/  # Uncomment when you add music packages
  ];

  # Additional user-level music configurations can go here
  # For example, music-specific user settings, DAW configurations, etc.
} 