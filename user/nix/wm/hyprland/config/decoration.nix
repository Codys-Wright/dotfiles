{ config, ... }:

''
decoration {
   rounding = 8
   dim_special = 0.0
   blur {
     enabled = true
     size = 5
     passes = 2
     ignore_opacity = true
     contrast = 1.17
     brightness = '' + (if (config.stylix.polarity == "dark") then "0.8" else "1.25") + ''

     xray = true
     special = true
     popups = true
   }
}
'' 