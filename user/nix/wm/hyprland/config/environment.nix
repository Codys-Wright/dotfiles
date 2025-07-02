{ config, pkgs, userSettings, ... }:

''
exec-once = dbus-update-activation-environment --systemd DISPLAY XAUTHORITY WAYLAND_DISPLAY XDG_SESSION_DESKTOP=Hyprland XDG_CURRENT_DESKTOP=Hyprland XDG_SESSION_TYPE=wayland
exec-once = hyprctl setcursor '' + config.gtk.cursorTheme.name + " " + builtins.toString config.gtk.cursorTheme.size + ''

env = XDG_CURRENT_DESKTOP,Hyprland
env = XDG_SESSION_DESKTOP,Hyprland
env = XDG_SESSION_TYPE,wayland
env = WLR_DRM_DEVICES,/dev/dri/card2:/dev/dri/card1
env = GDK_BACKEND,wayland,x11,*
env = QT_QPA_PLATFORM,wayland;xcb
env = QT_QPA_PLATFORMTHEME,qt5ct
env = QT_AUTO_SCREEN_SCALE_FACTOR,1
env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1
env = CLUTTER_BACKEND,wayland
env = GDK_PIXBUF_MODULE_FILE,${pkgs.librsvg}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache

exec-once = hyprprofile Default

exec-once = ydotoold
#exec-once = STEAM_FRAME_FORCE_CLOSE=1 steam -silent
exec-once = nm-applet
exec-once = blueman-applet
exec-once = GOMAXPROCS=1 syncthing --no-browser
exec-once = protonmail-bridge --noninteractive
exec-once = waybar
exec-once = emacs --daemon

exec-once = hypridle
exec-once = sleep 5 && libinput-gestures
exec-once = obs-notification-mute-daemon

exec-once = hyprpaper
'' 