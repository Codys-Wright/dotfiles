{ config, pkgs, userSettings, ... }:

{
  env = [
    "NIXOS_OZONE_WL,1"
    "_JAVA_AWT_WM_NONREPARENTING,1"
    "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
    "QT_QPA_PLATFORM,wayland"
    "SDL_VIDEODRIVER,wayland"
    "GDK_BACKEND,wayland"
    "LIBVA_DRIVER_NAME,nvidia"
    "XDG_SESSION_TYPE,wayland"
    "XDG_SESSION_DESKTOP,Hyprland"
    "XDG_CURRENT_DESKTOP,Hyprland"
    "GBM_BACKEND,nvidia-drm"
    "__GLX_VENDOR_LIBRARY_NAME,nvidia"
  ];

  exec-once = [
    "wl-paste --type text --watch cliphist store"
    "wl-paste --type image --watch cliphist store"
    "eval $(gnome-keyring-daemon --start --components=secrets,ssh,gpg,pkcs11)"
    "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP &"
    "hash dbus-update-activation-environment 2>/dev/null"
    "export SSH_AUTH_SOCK"
    "polkit-kde-authentication-agent-1"
  ];
} 