{ config, lib, pkgs, inputs, userSettings, ... }:

let
  cfg = config.services.xremap;
in
{
  imports = [ inputs.xremap.nixosModules.default ];

  services.xremap = {
    enable = true;
    userName = userSettings.username;
    config = {
      modmap = [
        {
          name = "Global";
          remap = {
            # Remap Caps Lock to Escape (very useful for vim users)
            "KEY_CAPSLOCK" = "KEY_ESC";
            
            # Remap Right Alt to Right Super (useful for gaming and window management)
            "KEY_RIGHTALT" = "KEY_RIGHTMETA";
          };
        }
      ];
      
      keymap = [
        {
          name = "Global";
          remap = {
            # Terminal shortcuts
            "C-S-t" = {
              launch = [ userSettings.term ];
            };
            
            # Browser shortcuts
            "C-S-b" = {
              launch = [ userSettings.browser ];
            };
            
            # Editor shortcuts
            "C-S-e" = {
              launch = [ userSettings.spawnEditor ];
            };
            
            # File manager
            "C-S-f" = {
              launch = [ "thunar" ];
            };
            
            # Screenshot
            "C-S-s" = {
              launch = [ "flameshot" "gui" ];
            };
            
            # Volume controls
            "XF86AudioRaiseVolume" = {
              launch = [ "pactl" "set-sink-volume" "@DEFAULT_SINK@" "+5%" ];
            };
            
            "XF86AudioLowerVolume" = {
              launch = [ "pactl" "set-sink-volume" "@DEFAULT_SINK@" "-5%" ];
            };
            
            "XF86AudioMute" = {
              launch = [ "pactl" "set-sink-mute" "@DEFAULT_SINK@" "toggle" ];
            };
            
            # Brightness controls
            "XF86MonBrightnessUp" = {
              launch = [ "brightnessctl" "set" "+5%" ];
            };
            
            "XF86MonBrightnessDown" = {
              launch = [ "brightnessctl" "set" "5%-" ];
            };
          };
        }
      ];
    };
  };

  # Ensure xremap has the necessary permissions
  security.wrappers.xremap = {
    source = "${pkgs.xremap}/bin/xremap";
    capabilities = "cap_sys_ptrace+ep";
    owner = "root";
    group = "root";
  };
} 