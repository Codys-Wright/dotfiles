{ config, ... }:

{
  decoration = {
    rounding = 15;
    active_opacity = 0.9;
    inactive_opacity = 0.8;
    fullscreen_opacity = 0.9;

    blur = {
      enabled = true;
      xray = true;
      special = false;
      new_optimizations = true;
      size = 14;
      passes = 4;
      brightness = 1;
      noise = 0.01;
      contrast = 1;
      popups = true;
      popups_ignorealpha = 0.6;
      ignore_opacity = false;
    };

    drop_shadow = true;
    shadow_ignore_window = true;
    shadow_range = 20;
    shadow_offset = "0 2";
    shadow_render_power = 4;
  };
} 