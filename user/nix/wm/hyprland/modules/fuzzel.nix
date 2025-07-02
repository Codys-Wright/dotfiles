{ config, pkgs, userSettings, ... }:
{
  home.packages = with pkgs; [
    papirus-icon-theme
  ];

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = userSettings.term;
        layer = "overlay";
        icon-theme = "Papirus-Dark";
        prompt = " ";
        font = userSettings.font;
        width = 40;
        horizontal-pad = 40;
        vertical-pad = 20;
        inner-pad = 10;
      };
      colors = {
        background = "1e1e2edd";
        text = "cdd6f4ff";
        selection = "45475aff";
        selection-text = "cdd6f4ff";
        border = "b4befeff";
        match = "f38ba8ff";
        selection-match = "f38ba8ff";
      };
      border = {
        radius = "10";
        width = "2";
      };
      dmenu = {
        exit-immediately-if-empty = "yes";
      };
    };
  };
}