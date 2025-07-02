{ pkgs, ... }:

{
  # Fonts are nice to have
  fonts.packages = with pkgs; [
    # Nerd Fonts
    nerd-fonts.fira-code
    nerd-fonts.hack
    nerd-fonts.jetbrains-mono
    nerd-fonts.ubuntu
    nerd-fonts.sauce-code-pro
    powerline
  ];

}
