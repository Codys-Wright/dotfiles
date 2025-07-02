{ config, pkgs, userSettings, ... }:
{
  services.swaync = {
    enable = true;
    settings = {
      positionX = "right";
      positionY = "top";
      layer = "overlay";
      control-center-layer = "top";
      layer-shell = true;
      cssPriority = "application";
      control-center-margin-top = 8;
      control-center-margin-bottom = 8;
      control-center-margin-right = 8;
      control-center-margin-left = 8;
      notification-2fa-command = true;
      notification-inline-replies = false;
      notification-icon-size = 64;
      notification-body-image-height = 100;
      notification-body-image-width = 200;
      timeout = 10;
      timeout-low = 5;
      timeout-critical = 0;
      fit-to-screen = true;
      control-center-width = 500;
      control-center-height = 600;
      notification-window-width = 500;
      keyboard-shortcuts = true;
      image-visibility = "when-available";
      transition-time = 200;
      hide-on-clear = false;
      hide-on-action = true;
      script-fail-notify = true;
    };
    style = ''
      .notification-row {
        outline: none;
      }

      .notification-row:focus,
      .notification-row:hover {
        background: rgba(203, 166, 247, 0.1);
      }

      .notification {
        border-radius: 12px;
        margin: 6px 12px;
        box-shadow: 0 0 0 1px rgba(0, 0, 0, 0.3), 0 1px 3px 1px rgba(0, 0, 0, 0.7),
          0 2px 6px 2px rgba(0, 0, 0, 0.3);
        padding: 0;
      }

      .notification-content {
        background: rgba(30, 30, 46, 0.9);
        padding: 6px;
        border-radius: 12px;
      }

      .notification-default-action,
      .notification-action {
        padding: 4px;
        margin: 0;
        box-shadow: none;
        background: rgba(30, 30, 46, 0.9);
        border: 1px solid rgba(69, 71, 90, 0.9);
        color: #cdd6f4;
        transition: all 0.15s ease-in-out;
      }

      .notification-default-action:hover,
      .notification-action:hover {
        -gtk-icon-effect: none;
        background: rgba(49, 50, 68, 0.9);
      }

      .notification-default-action {
        border-radius: 12px;
      }

      .close-button {
        background: rgba(243, 139, 168, 0.9);
        color: #1e1e2e;
        text-shadow: none;
        padding: 0;
        border-radius: 100%;
        margin-top: 10px;
        margin-right: 16px;
      }

      .close-button:hover {
        box-shadow: none;
        background: rgba(243, 139, 168, 1);
        transition: all 0.15s ease-in-out;
        border: none;
      }

      .notification-action {
        border-radius: 0;
        border-top: none;
        border-right: none;
        border-left: none;
      }

      .inline-reply {
        margin-top: 8px;
      }
      .inline-reply-entry {
        background: rgba(69, 71, 90, 0.9);
        color: #cdd6f4;
        caret-color: #cdd6f4;
        border: 1px solid rgba(88, 91, 112, 0.9);
        border-radius: 12px;
      }
      .inline-reply-button {
        margin-left: 4px;
        background: rgba(137, 180, 250, 0.9);
        color: #1e1e2e;
        border: 1px solid rgba(137, 180, 250, 0.9);
        border-radius: 12px;
      }
      .inline-reply-button:disabled {
        background: rgba(88, 91, 112, 0.9);
        color: #6c7086;
        border: 1px solid rgba(88, 91, 112, 0.9);
      }
      .inline-reply-button:hover {
        background: rgba(137, 180, 250, 1);
      }

      .body-image {
        margin-top: 6px;
        background-color: #cdd6f4;
        border-radius: 12px;
      }

      .summary {
        font-size: 16px;
        font-weight: bold;
        background: transparent;
        color: #cdd6f4;
        text-shadow: none;
      }

      .time {
        font-size: 16px;
        font-weight: bold;
        background: transparent;
        color: #cdd6f4;
        text-shadow: none;
        margin-right: 18px;
      }

      .body {
        font-size: 15px;
        font-weight: normal;
        background: transparent;
        color: #cdd6f4;
        text-shadow: none;
      }

      .control-center {
        background: rgba(30, 30, 46, 0.8);
        border: 1px solid rgba(69, 71, 90, 0.9);
        border-radius: 12px;
      }

      .control-center-list {
        background: transparent;
      }

      .control-center-list-placeholder {
        opacity: 0.5;
      }

      .floating-notifications {
        background: transparent;
      }

      .blank-window {
        background: alpha(black, 0.25);
      }

      .widget-title {
        color: #cdd6f4;
        background: rgba(30, 30, 46, 0.9);
        padding: 5px 10px;
        margin: 10px 10px 5px 10px;
        font-size: 1.5rem;
        border-radius: 5px;
      }

      .widget-title > button {
        font-size: 1rem;
        color: #cdd6f4;
        text-shadow: none;
        background: rgba(30, 30, 46, 0.9);
        border: 1px solid rgba(69, 71, 90, 0.9);
        box-shadow: none;
        border-radius: 5px;
      }

      .widget-title > button:hover {
        background: rgba(49, 50, 68, 0.9);
      }

      .widget-dnd {
        background: rgba(30, 30, 46, 0.9);
        padding: 5px 10px;
        margin: 10px 10px 5px 10px;
        border-radius: 5px;
        font-size: large;
        color: #cdd6f4;
      }

      .widget-dnd > switch {
        border-radius: 4px;
        background: rgba(88, 91, 112, 0.9);
      }

      .widget-dnd > switch:checked {
        background: rgba(137, 180, 250, 0.9);
      }

      .widget-dnd > switch slider {
        background: rgba(205, 214, 244, 0.9);
        border-radius: 5px;
      }

      .widget-dnd > switch:checked slider {
        background: rgba(30, 30, 46, 0.9);
      }

      .widget-label {
        margin: 10px 10px 5px 10px;
      }

      .widget-label > label {
        font-size: 1rem;
        color: #cdd6f4;
      }

      .widget-mpris {
        color: #cdd6f4;
        background: rgba(30, 30, 46, 0.9);
        padding: 5px 10px;
        margin: 10px 10px 5px 10px;
        border-radius: 5px;
      }

      .widget-mpris > box > button {
        border-radius: 0;
      }

      .widget-mpris-player {
        padding: 5px 10px;
        margin: 10px;
      }

      .widget-mpris-title {
        font-weight: bold;
        font-size: 1.25rem;
      }

      .widget-mpris-subtitle {
        font-size: 1.1rem;
      }

      .widget-buttons-grid {
        font-size: x-large;
        padding: 5px;
        margin: 10px 10px 5px 10px;
        border-radius: 5px;
        background: rgba(30, 30, 46, 0.9);
      }

      .widget-buttons-grid > flowbox > flowboxchild > button {
        margin: 3px;
        background: rgba(69, 71, 90, 0.9);
        border-radius: 5px;
        color: #cdd6f4;
      }

      .widget-buttons-grid > flowbox > flowboxchild > button:hover {
        background: rgba(88, 91, 112, 0.9);
      }

      .widget-menubar > box > .menu-button-bar > button {
        border: none;
        background: transparent;
      }

      .topbar-buttons > button {
        border: none;
        background: transparent;
      }

      .widget-volume {
        background: rgba(30, 30, 46, 0.9);
        padding: 5px;
        margin: 10px 10px 5px 10px;
        border-radius: 5px;
        font-size: x-large;
        color: #cdd6f4;
      }

      .widget-volume > box > button {
        background: rgba(137, 180, 250, 0.2);
        border: none;
      }

      .per-app-volume {
        background-color: rgba(69, 71, 90, 0.9);
        padding: 4px 8px 8px;
        margin: 0 8px 8px;
        border-radius: 5px;
      }

      .widget-backlight {
        background: rgba(30, 30, 46, 0.9);
        padding: 5px;
        margin: 10px 10px 5px 10px;
        border-radius: 5px;
        font-size: x-large;
        color: #cdd6f4;
      }
    '';
  };
}