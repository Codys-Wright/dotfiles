{ pkgs-stable, ... }:

{
  # Fonts are nice to have
  fonts.packages = with pkgs; [
    # Fonts
    nerdfonts.jetbrains-mono
    nerdfonts.hack
    powerline
  ];

}
