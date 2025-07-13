{ config, userSettings, pkgs, ... }:

{
  windowrulev2 = [
    # ===== REAPER DAW RULES =====
    # Main Reaper window - let it manage itself naturally
    "workspace 1,class:^(REAPER)$"
    "opacity 1.0 override,class:^(REAPER)$"
    
    # Only float specific dialog windows, not all child windows
    "float,class:REAPER,title:^(Preferences)$"
    "float,class:REAPER,title:^(Project Settings)$"
    "float,class:REAPER,title:^(Render to file)$"
    "float,class:REAPER,title:^(Export)$"
    "float,class:REAPER,title:^(Save As)$"
    "float,class:REAPER,title:^(Open)$"
    
    # Move dialogs to cursor but don't force size
    "move cursor,class:REAPER,floating:1"
    
    # Performance optimization for main window only
    "noanim,class:^(REAPER)$,title:^(REAPER)$"
    
    # ===== AUDIO PRODUCTION APPLICATIONS =====
    # JACK Control
    "float,class:^(qjackctl)$"
    "move cursor,class:^(qjackctl)$"
    "size 400 300,class:^(qjackctl)$"
    
    # PulseAudio Volume Control
    "float,class:^(pavucontrol)$"
    "move cursor,class:^(pavucontrol)$"
    "size 500 400,class:^(pavucontrol)$"
    
    # ALSA Mixer
    "float,class:^(alsamixer)$"
    "move cursor,class:^(alsamixer)$"
    "size 600 400,class:^(alsamixer)$"
    
    # Carla (plugin host)
    "float,class:^(carla)$"
    "move cursor,class:^(carla)$"
    "size 800 600,class:^(carla)$"
    
    # Ardour (alternative DAW)
    "fullscreen,class:^(ardour)$"
    "stayfocused,class:^(ardour)$"
    "noanim,class:^(ardour)$"
    
    # ===== WINE APPLICATIONS =====
    # Bottles (Wine application manager)
    "float,class:^(com.usebottles.bottles)$"
    "move cursor,class:^(com.usebottles.bottles)$"
    "size 1000 700,class:^(com.usebottles.bottles)$"
    "opacity 1.0 override,class:^(com.usebottles.bottles)$"
    "noanim,class:^(com.usebottles.bottles)$"
    
    # Wine applications (general) - less aggressive rules
    "float,class:^(wine)$"
    "move cursor,class:^(wine)$"
    "opacity 1.0 override,class:^(wine)$"
    
    # Wine dialogs - float but don't force size
    "float,class:^(wine),title:^(.*Setup.*)$"
    "float,class:^(wine),title:^(.*Install.*)$"
    "float,class:^(wine),title:^(.*Config.*)$"
    "move cursor,class:^(wine),floating:1"
    
    # ===== UTILITY APPLICATIONS =====
    # Calculator
    "float,class:^(calculator)$"
    "move cursor,class:^(calculator)$"
    "size 400 600,class:^(calculator)$"
    
    # File manager dialogs
    "float,class:^(thunar)$,title:^(Properties)$"
    "float,class:^(thunar)$,title:^(Rename)$"
    "move cursor,class:^(thunar),floating:1"
    
    # ===== BROWSER RULES =====
    # Picture-in-picture windows
    "float,class:^(firefox)$,title:^(Picture-in-Picture)$"
    "float,class:^(chromium)$,title:^(Picture-in-Picture)$"
    "move cursor,class:^(firefox),floating:1"
    "move cursor,class:^(chromium),floating:1"
    
    # ===== SYSTEM DIALOGS =====
    # Polkit authentication dialogs
    "float,class:^(polkit-gnome-authentication-agent-1)$"
    "move cursor,class:^(polkit-gnome-authentication-agent-1)$"
    
    # Notification center
    "float,class:^(swaync)$"
    "move cursor,class:^(swaync)$"
    
    # ===== GAMING =====
    # Steam
    "fullscreen,class:^(steam)$"
    "stayfocused,class:^(steam)$"
    
    # ===== DEVELOPMENT =====
    # IDE windows
    "workspace 12,class:^(code)$"
    "workspace 13,class:^(jetbrains-idea)$"
    "workspace 13,class:^(intellij-idea)$"
    "workspace 13,class:^(pycharm)$"
    "workspace 13,class:^(webstorm)$"
    
    # ===== COMMUNICATION =====
    # Discord
    "workspace 6,class:^(discord)$"
    "float,class:^(discord)$,title:^(Discord)$"
    
    # Slack
    "workspace 6,class:^(slack)$"
    
    # ===== MEDIA =====
    # Video players
    "fullscreen,class:^(mpv)$"
    "fullscreen,class:^(vlc)$"
    "stayfocused,class:^(mpv)$"
    "stayfocused,class:^(vlc)$"
    
    # ===== WORKSPACE ASSIGNMENTS =====
    # Left Monitor (DP-4 - Acer) - Workspaces 1-4
    "workspace 1,class:^(REAPER)$"
    "workspace 2,class:^(obsidian)$"
    "workspace 3,class:^(firefox)$"
    "workspace 4,class:^(thunderbird)$"
    
    # Center Monitor (DP-3 - AOC) - Primary - Workspaces 5, 12, 13, 6
    "workspace 5,class:^(code)$"
    "workspace 12,class:^(jetbrains-idea)$"
    "workspace 13,class:^(intellij-idea)$"
    "workspace 6,class:^(discord)$"
    
    # Right Monitor (DP-5 - Acer) - Workspaces 7-10
    "workspace 7,class:^(steam)$"
    "workspace 8,class:^(spotify)$"
    "workspace 9,class:^(telegram)$"
    "workspace 10,class:^(signal)$"
  ];
} 