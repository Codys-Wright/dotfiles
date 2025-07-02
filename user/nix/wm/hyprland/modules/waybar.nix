{ config, pkgs, userSettings, ... }:
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = [
      {
        layer = "top";
        position = "top";
        modules-left = ["hyprland/workspaces"];
        modules-center = ["hyprland/window"];
        modules-right = ["network" "backlight" "battery" "clock" "tray"];

        "hyprland/workspaces" = {
          disable-scroll = true;
          sort-by-name = false;
          all-outputs = true;
          persistent-workspaces = {
            "1" = [];
            "2" = [];
            "3" = [];
            "4" = [];
            "5" = [];
            "6" = [];
            "7" = [];
            "8" = [];
            "9" = [];
            "10" = [];
          };
        };

        "hyprland/window" = {
          format = "{}";
          max-length = 50;
        };

        "tray" = {
          icon-size = 21;
          spacing = 10;
        };

        "clock" = {
          timezone = userSettings.timezone or "America/Chicago";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "  {:%d/%m/%Y}";
          format = "  {:%H:%M}";
        };

        "network" = {
          format-wifi = "{icon} ({signalStrength}%)";
          format-ethernet = "{ifname}: {ipaddr}/{cidr} 󰈀";
          format-linked = "{ifname} (No IP) 󰌘";
          format-disconnected = "Disconnected 󰟦";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
          format-icons = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
        };

        "backlight" = {
          device = "intel_backlight";
          format = "{icon} {percent}%";
          format-icons = ["" "" "" "" "" "" "" "" ""];
        };

        "battery" = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󱟢 {capacity}%";
          format-alt = "{icon} {time}";
          format-icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
        };
      }
    ];

    style = ''
      * {
        font-family: '${userSettings.font}';
        font-size: 14px;
        min-height: 0;
      }

      window#waybar {
        background: rgba(30, 30, 46, 0.8);
        color: #cdd6f4;
        border-radius: 12px;
        margin: 8px;
        padding: 0;
      }

      #workspaces {
        border-radius: 10px;
        margin: 5px;
        background-color: rgba(69, 71, 90, 0.8);
        margin-left: 1rem;
      }

      #workspaces button {
        color: #b4befe;
        border-radius: 10px;
        padding: 0.4rem 0.8rem;
        margin: 2px;
        transition: all 0.3s ease-in-out;
      }

      #workspaces button.active {
        color: #fab387;
        background-color: rgba(250, 179, 135, 0.2);
      }

      #workspaces button:hover {
        color: #fab387;
        background-color: rgba(250, 179, 135, 0.1);
      }

      #window {
        color: #cdd6f4;
        font-weight: bold;
      }

      #tray,
      #backlight,
      #network,
      #clock,
      #battery {
        background-color: rgba(69, 71, 90, 0.8);
        padding: 0.5rem 1rem;
        margin: 5px 2px;
        border-radius: 10px;
      }

      #clock {
        color: #89b4fa;
        margin-right: 1rem;
      }

      #battery {
        color: #a6e3a1;
      }

      #battery.charging {
        color: #a6e3a1;
      }

      #battery.warning:not(.charging) {
        color: #f9e2af;
      }

      #battery.critical:not(.charging) {
        color: #f38ba8;
      }

      #backlight {
        color: #f9e2af;
      }

      #network {
        color: #89dceb;
      }

      #tray {
        margin-right: 1rem;
      }
    '';
  };
} 