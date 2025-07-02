{ config, userSettings, ... }:

''
bind=SUPER,Z,exec,if hyprctl clients | grep scratch_term; then echo "scratch_term respawn not needed"; else alacritty --class scratch_term; fi
bind=SUPER,Z,togglespecialworkspace,scratch_term
bind=SUPER,F,exec,if hyprctl clients | grep scratch_ranger; then echo "scratch_ranger respawn not needed"; else kitty --class scratch_ranger -e ranger; fi
bind=SUPER,F,togglespecialworkspace,scratch_ranger
bind=SUPER,N,exec,if hyprctl clients | grep scratch_numbat; then echo "scratch_ranger respawn not needed"; else alacritty --class scratch_numbat -e numbat; fi
bind=SUPER,N,togglespecialworkspace,scratch_numbat
bind=SUPER,M,exec,if hyprctl clients | grep lollypop; then echo "scratch_ranger respawn not needed"; else lollypop; fi
bind=SUPER,M,togglespecialworkspace,scratch_music
bind=SUPER,B,exec,if hyprctl clients | grep scratch_btm; then echo "scratch_ranger respawn not needed"; else alacritty --class scratch_btm -e btm; fi
bind=SUPER,B,togglespecialworkspace,scratch_btm
bind=SUPER,D,exec,if hyprctl clients | grep Element; then echo "scratch_ranger respawn not needed"; else element-desktop; fi
bind=SUPER,D,togglespecialworkspace,scratch_element
bind=SUPER,code:172,exec,togglespecialworkspace,scratch_pavucontrol
bind=SUPER,code:172,exec,if hyprctl clients | grep pavucontrol; then echo "scratch_ranger respawn not needed"; else pavucontrol; fi

$scratchpadsize = size 80% 85%

$scratch_term = class:^(scratch_term)$
windowrulev2 = float,$scratch_term
windowrulev2 = $scratchpadsize,$scratch_term
windowrulev2 = workspace special:scratch_term ,$scratch_term
windowrulev2 = center,$scratch_term

$float_term = class:^(float_term)$
windowrulev2 = float,$float_term
windowrulev2 = center,$float_term

$scratch_ranger = class:^(scratch_ranger)$
windowrulev2 = float,$scratch_ranger
windowrulev2 = $scratchpadsize,$scratch_ranger
windowrulev2 = workspace special:scratch_ranger silent,$scratch_ranger
windowrulev2 = center,$scratch_ranger

$scratch_numbat = class:^(scratch_numbat)$
windowrulev2 = float,$scratch_numbat
windowrulev2 = $scratchpadsize,$scratch_numbat
windowrulev2 = workspace special:scratch_numbat silent,$scratch_numbat
windowrulev2 = center,$scratch_numbat

$scratch_btm = class:^(scratch_btm)$
windowrulev2 = float,$scratch_btm
windowrulev2 = $scratchpadsize,$scratch_btm
windowrulev2 = workspace special:scratch_btm silent,$scratch_btm
windowrulev2 = center,$scratch_btm

windowrulev2 = float,class:^(Element)$
windowrulev2 = size 85% 90%,class:^(Element)$
windowrulev2 = workspace special:scratch_element silent,class:^(Element)$
windowrulev2 = center,class:^(Element)$

windowrulev2 = float,class:^(lollypop)$
windowrulev2 = size 85% 90%,class:^(lollypop)$
windowrulev2 = workspace special:scratch_music silent,class:^(lollypop)$
windowrulev2 = center,class:^(lollypop)$

$pavucontrol = class:^(org.pulseaudio.pavucontrol)$
windowrulev2 = float,$pavucontrol
windowrulev2 = size 86% 40%,$pavucontrol
windowrulev2 = move 50% 6%,$pavucontrol
windowrulev2 = workspace special silent,$pavucontrol
windowrulev2 = opacity 0.80,$pavucontrol
'' 