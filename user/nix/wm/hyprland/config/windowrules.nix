{ ... }:

''
$savetodisk = title:^(Save to Disk)$
windowrulev2 = float,$savetodisk
windowrulev2 = size 70% 75%,$savetodisk
windowrulev2 = center,$savetodisk

$miniframe = title:\*Minibuf.*
windowrulev2 = float,$miniframe
windowrulev2 = size 64% 50%,$miniframe
windowrulev2 = move 18% 25%,$miniframe
windowrulev2 = animation popin 1 20,$miniframe

windowrulev2 = float,class:^(pokefinder)$
windowrulev2 = float,class:^(Waydroid)$

windowrulev2 = float,title:^(Blender Render)$
windowrulev2 = size 86% 85%,title:^(Blender Render)$
windowrulev2 = center,title:^(Blender Render)$
windowrulev2 = float,class:^(org.inkscape.Inkscape)$
windowrulev2 = float,class:^(pinta)$
windowrulev2 = float,class:^(krita)$
windowrulev2 = float,class:^(Gimp)
windowrulev2 = float,class:^(Gimp)
windowrulev2 = float,class:^(libresprite)$

windowrulev2 = opacity 0.80,title:ORUI

windowrulev2 = opacity 1.0,class:^(org.qutebrowser.qutebrowser),fullscreen:1
windowrulev2 = opacity 0.85,class:^(Element)$
windowrulev2 = opacity 0.85,class:^(Logseq)$
windowrulev2 = opacity 0.85,class:^(lollypop)$
windowrulev2 = opacity 1.0,class:^(Brave-browser),fullscreen:1
windowrulev2 = opacity 1.0,class:^(librewolf),fullscreen:1
windowrulev2 = opacity 0.85,title:^(My Local Dashboard Awesome Homepage - qutebrowser)$
windowrulev2 = opacity 0.85,title:\[.*\] - My Local Dashboard Awesome Homepage
windowrulev2 = opacity 0.85,class:^(org.keepassxc.KeePassXC)$
windowrulev2 = opacity 0.85,class:^(org.gnome.Nautilus)$
windowrulev2 = opacity 0.85,class:^(org.gnome.Nautilus)$

windowrulev2 = opacity 0.85,initialTitle:^(Notes)$,initialClass:^(Brave-browser)$
'' 