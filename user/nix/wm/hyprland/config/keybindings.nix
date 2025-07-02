{ config, userSettings, ... }:

''
bind=SUPER,code:9,exec,nwggrid-wrapper
bind=SUPER,code:66,exec,nwggrid-wrapper
bind=SUPER,SPACE,fullscreen,1
bind=SUPERSHIFT,F,fullscreen,0
bind=SUPER,Y,workspaceopt,allfloat
bind=ALT,TAB,cyclenext
bind=ALT,TAB,bringactivetotop
bind=ALTSHIFT,TAB,cyclenext,prev
bind=ALTSHIFT,TAB,bringactivetotop
bind=SUPER,V,exec,wl-copy $(wl-paste | tr '\n' ' ')
bind=SUPERSHIFT,T,exec,screenshot-ocr
bind=CTRLALT,Delete,exec,hyprctl kill
bind=SUPERSHIFT,K,exec,hyprctl kill
bind=SUPER,W,exec,nwg-dock-wrapper

bind=,code:172,exec,lollypop -t
bind=,code:208,exec,lollypop -t
bind=,code:209,exec,lollypop -t
bind=,code:174,exec,lollypop -s
bind=,code:171,exec,lollypop -n
bind=,code:173,exec,lollypop -p

bind = SUPER,R,pass,^(com\.obsproject\.Studio)$
bind = SUPERSHIFT,R,pass,^(com\.obsproject\.Studio)$

bind=SUPER,RETURN,exec,'' + userSettings.term + ''

bind=SUPERSHIFT,RETURN,exec,'' + userSettings.term + " " + '' --class float_term

bind=SUPER,A,exec,'' + userSettings.spawnEditor + ''

bind=SUPER,S,exec,'' + userSettings.spawnBrowser + ''

bind=SUPERCTRL,S,exec,container-open # qutebrowser only

bind=SUPERCTRL,P,pin

bind=SUPER,code:47,exec,fuzzel
bind=SUPER,X,exec,fnottctl dismiss
bind=SUPERSHIFT,X,exec,fnottctl dismiss all
bind=SUPER,Q,killactive
bind=SUPERSHIFT,Q,exit
bindm=SUPER,mouse:272,movewindow
bindm=SUPER,mouse:273,resizewindow
bind=SUPER,T,togglefloating
bind=SUPER,G,exec,hyprctl dispatch focusworkspaceoncurrentmonitor 9 && pegasus-fe;
bind=,code:148,exec,''+ userSettings.term + " "+''-e numbat

bind=,code:107,exec,grim -g "$(slurp)"
bind=SHIFT,code:107,exec,grim -g "$(slurp -o)"
bind=SUPER,code:107,exec,grim
bind=CTRL,code:107,exec,grim -g "$(slurp)" - | wl-copy
bind=SHIFTCTRL,code:107,exec,grim -g "$(slurp -o)" - | wl-copy
bind=SUPERCTRL,code:107,exec,grim - | wl-copy

bind=,code:122,exec,swayosd-client --output-volume lower
bind=,code:123,exec,swayosd-client --output-volume raise
bind=,code:121,exec,swayosd-client --output-volume mute-toggle
bind=,code:256,exec,swayosd-client --output-volume mute-toggle
bind=SHIFT,code:122,exec,swayosd-client --output-volume lower
bind=SHIFT,code:123,exec,swayosd-client --output-volume raise
bind=,code:232,exec,swayosd-client --brightness lower
bind=,code:233,exec,swayosd-client --brightness raise
bind=,code:237,exec,brightnessctl --device='asus::kbd_backlight' set 1-
bind=,code:238,exec,brightnessctl --device='asus::kbd_backlight' set +1
bind=,code:255,exec,airplane-mode
bind=SUPER,C,exec,wl-copy $(hyprpicker)

bind=SUPERSHIFT,S,exec,systemctl suspend
bindl=,switch:on:Lid Switch,exec,loginctl lock-session
bind=SUPERCTRL,L,exec,loginctl lock-session

bind=SUPER,H,movefocus,l
bind=SUPER,J,movefocus,d
bind=SUPER,K,movefocus,u
bind=SUPER,L,movefocus,r

bind=SUPERSHIFT,H,movewindow,l
bind=SUPERSHIFT,J,movewindow,d
bind=SUPERSHIFT,K,movewindow,u
bind=SUPERSHIFT,L,movewindow,r

bind=SUPER,1,focusworkspaceoncurrentmonitor,1
bind=SUPER,2,focusworkspaceoncurrentmonitor,2
bind=SUPER,3,focusworkspaceoncurrentmonitor,3
bind=SUPER,4,focusworkspaceoncurrentmonitor,4
bind=SUPER,5,focusworkspaceoncurrentmonitor,5
bind=SUPER,6,focusworkspaceoncurrentmonitor,6
bind=SUPER,7,focusworkspaceoncurrentmonitor,7
bind=SUPER,8,focusworkspaceoncurrentmonitor,8
bind=SUPER,9,focusworkspaceoncurrentmonitor,9

bind=SUPERCTRL,right,exec,hyprnome
bind=SUPERCTRL,left,exec,hyprnome --previous
bind=SUPERSHIFT,right,exec,hyprnome --move
bind=SUPERSHIFT,left,exec,hyprnome --previous --move

bind=SUPERSHIFT,1,movetoworkspace,1
bind=SUPERSHIFT,2,movetoworkspace,2
bind=SUPERSHIFT,3,movetoworkspace,3
bind=SUPERSHIFT,4,movetoworkspace,4
bind=SUPERSHIFT,5,movetoworkspace,5
bind=SUPERSHIFT,6,movetoworkspace,6
bind=SUPERSHIFT,7,movetoworkspace,7
bind=SUPERSHIFT,8,movetoworkspace,8
bind=SUPERSHIFT,9,movetoworkspace,9

bind=SUPER,equal, exec, hyprctl keyword cursor:zoom_factor "$(hyprctl getoption cursor:zoom_factor | grep float | awk '{print $2 + 0.5}')"
bind=SUPER,minus, exec, hyprctl keyword cursor:zoom_factor "$(hyprctl getoption cursor:zoom_factor | grep float | awk '{print $2 - 0.5}')"

bind=SUPER,I,exec,networkmanager_dmenu
bind=SUPER,P,exec,keepmenu
bind=SUPERSHIFT,P,exec,hyprprofile-dmenu
bind=SUPERCTRL,R,exec,phoenix refresh
'' 