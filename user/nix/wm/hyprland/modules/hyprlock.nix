{ config, pkgs, userSettings, ... }:
{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 300;
        hide_cursor = true;
        no_fade_in = false;
      };

      background = [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
        }
      ];

      input-field = [
        {
          size = "200, 50";
          position = "0, -80";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(202, 211, 245)";
          inner_color = "rgb(69, 71, 90)";
          outer_color = "rgb(24, 25, 38)";
          outline_thickness = 5;
          shadow_passes = 2;
        }
      ];

      label = [
        {
          monitor = "";
          text = "Hi ${userSettings.name}";
          color = "rgba(200, 200, 200, 1.0)";
          font_size = 55;
          font_family = userSettings.font;
          position = "0, 80";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "$TIME";
          color = "rgba(200, 200, 200, 1.0)";
          font_size = 90;
          font_family = userSettings.font;
          position = "0, 0";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}