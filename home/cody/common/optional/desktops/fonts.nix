{ pkgs, ... }:
{

  # TODO add ttf-font-awesome or font-awesome for waybar
  fontProfiles = {
    enable = true;
    monospace = {
      family = "FiraCode Nerd Font";
      package = pkgs.nerd-fonts.fira-code;
    };
    regular = {
      family = "Fira Sans";
      package = pkgs.fira;
    };
  };
}
