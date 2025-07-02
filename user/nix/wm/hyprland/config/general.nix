{ config, ... }:

''
general {
  layout = master
  border_size = 5
  col.active_border = 0xff'' + config.lib.stylix.colors.base08 + " " + ''0xff'' + config.lib.stylix.colors.base09 + " " + ''0xff'' + config.lib.stylix.colors.base0A + " " + ''0xff'' + config.lib.stylix.colors.base0B + " " + ''0xff'' + config.lib.stylix.colors.base0C + " " + ''0xff'' + config.lib.stylix.colors.base0D + " " + ''0xff'' + config.lib.stylix.colors.base0E + " " + ''0xff'' + config.lib.stylix.colors.base0F + " " + ''270deg

  col.inactive_border = 0xaa'' + config.lib.stylix.colors.base02 + ''

      resize_on_border = true
      gaps_in = 7
      gaps_out = 7
 }
'' 