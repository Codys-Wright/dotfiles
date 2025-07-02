{ config, pkgs, ... }:

{
  imports = [
    ./gaming/app/games/games.nix
    # ./gaming/lang/  # Uncomment when you add gaming language tools
    # ./gaming/shell/  # Uncomment when you add gaming shell configs
    # ./gaming/pkgs/  # Uncomment when you add gaming packages
  ];

  # Additional user-level gaming configurations can go here
  # For example, gaming-specific user settings, keybindings, etc.
} 