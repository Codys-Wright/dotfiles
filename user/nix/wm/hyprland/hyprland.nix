{ config, lib, pkgs, userSettings, systemSettings, ... }:
{
  imports = [
    ./modules/waybar.nix
    ./modules/fuzzel.nix
    ./modules/hyprlock.nix
    ./modules/wlogout.nix
    ./modules/swaync.nix
  ];

  home.packages = with pkgs; [
    wl-clipboard
    slurp
    grim
    swappy
    cliphist
    brightnessctl
    hyprpaper
    polkit_gnome
  ];

  services.cliphist.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;

    settings = {
      "$terminal" = userSettings.term;
      "$mod" = "SUPER";

      monitor = [
        ",preferred,auto,1"
      ];

      xwayland = {
        force_zero_scaling = true;
      };
    } 
    // (import ./config/general.nix { inherit config; })
    // (import ./config/input.nix { })
    // (import ./config/decoration.nix { inherit config; })
    // (import ./config/animations.nix { inherit config; })
    // (import ./config/dwindle.nix { })
    // (import ./config/cursor.nix { })
    // (import ./config/misc.nix { inherit config userSettings; })
    // (import ./config/environment.nix { inherit config pkgs userSettings; })
    // {
      bind = import ./config/keybindings.nix { inherit config userSettings pkgs; };
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
  };
}

