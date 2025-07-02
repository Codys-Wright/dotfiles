{ config, ... }:

''
bezier = wind, 0.05, 0.9, 0.1, 1.05
bezier = winIn, 0.1, 1.1, 0.1, 1.0
bezier = winOut, 0.3, -0.3, 0, 1
bezier = liner, 1, 1, 1, 1
bezier = linear, 0.0, 0.0, 1.0, 1.0

animations {
     enabled = yes
     animation = windowsIn, 1, 6, winIn, popin
     animation = windowsOut, 1, 5, winOut, popin
     animation = windowsMove, 1, 5, wind, slide
     animation = border, 1, 10, default
     animation = borderangle, 1, 100, linear, loop
     animation = fade, 1, 10, default
     animation = workspaces, 1, 5, wind
     animation = windows, 1, 6, wind, slide
     animation = specialWorkspace, 1, 6, default, slidefadevert -50%
}
'' 