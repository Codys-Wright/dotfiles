{ config, pkgs, userSettings, ... }:
{
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 35;
        modules-left = [ "clock" ];
        modules-center = [ ];
        modules-right = [ "tray" ];
        clock = { format = "{:%H:%M}"; interval = 60; };
        tray = { spacing = 10; };
      };
    };
  };

  # Hyprland extra config for waybar
  waybarExtraConfig = ''
    exec-once = waybar
    layerrule = blur,waybar
    layerrule = xray,waybar
    blurls = waybar
  '';
} 