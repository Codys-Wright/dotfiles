{ config, pkgs, userSettings, ... }:
{
  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "lock";
        action = "${pkgs.hyprlock}/bin/hyprlock";
        text = "Lock";
        keybind = "l";
      }
      {
        label = "logout";
        action = "hyprctl dispatch exit";
        text = "Logout";
        keybind = "e";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }
      {
        label = "suspend";
        action = "systemctl suspend";
        text = "Suspend";
        keybind = "u";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }
      {
        label = "hibernate";
        action = "systemctl hibernate";
        text = "Hibernate";
        keybind = "h";
      }
    ];
    style = ''
      * {
        background-image: none;
        box-shadow: none;
      }

      window {
        background-color: rgba(12, 12, 12, 0.9);
      }

      button {
        color: #cdd6f4;
        background-color: #1e1e2e;
        border-style: solid;
        border-width: 2px;
        background-repeat: no-repeat;
        background-position: center;
        background-size: 25%;
        border-radius: 10px;
        margin: 5px;
        transition: box-shadow 0.2s ease-in-out, background-color 0.2s ease-in-out;
      }

      button:focus, button:active, button:hover {
        background-color: #313244;
        outline-style: none;
      }

      #lock {
        border-color: #f9e2af;
      }

      #logout {
        border-color: #a6e3a1;
      }

      #shutdown {
        border-color: #f38ba8;
      }

      #suspend {
        border-color: #89b4fa;
      }

      #reboot {
        border-color = #fab387;
      }

      #hibernate {
        border-color: #cba6f7;
      }
    '';
  };
}