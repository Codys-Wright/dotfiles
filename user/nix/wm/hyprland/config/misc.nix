{ config, userSettings, ... }:

''
misc {
   disable_hyprland_logo = true
   mouse_move_enables_dpms = true
   enable_swallow = true
   swallow_regex = (scratch_term)|(Alacritty)|(kitty)
   font_family = '' + userSettings.font + ''
}
'' 