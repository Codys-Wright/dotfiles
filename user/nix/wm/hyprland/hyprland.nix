{ config, lib, pkgs, userSettings, systemSettings, pkgs-nwg-dock-hyprland, ... }:
{
  imports = [
    ../../app/terminal/alacritty.nix
    ../../app/terminal/kitty.nix
    (import ../../app/dmenu-scripts/networkmanager-dmenu.nix {
      dmenu_command = "fuzzel -d"; inherit config lib pkgs;
    })
    ../input/nihongo.nix
  ] ++
  (if (systemSettings.profile == "personal") then
    [ (import ./hyprprofiles/hyprprofiles.nix {
        dmenuCmd = "fuzzel -d"; inherit config lib pkgs; })]
  else
    []);

  gtk.cursorTheme = {
    package = pkgs.quintom-cursor-theme;
    name = if (config.stylix.polarity == "light") then "Quintom_Ink" else "Quintom_Snow";
    size = 36;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    plugins = [ ];
    settings = { };
    extraConfig = ''
      ${import ./config/environment.nix { inherit config pkgs userSettings; }}
      ${import ./config/animations.nix { inherit config; }}
      ${import ./config/general.nix { inherit config; }}
      ${import ./config/monitors.nix { inherit config; }}
      ${import ./config/input.nix { inherit config; }}
      ${import ./config/decoration.nix { inherit config; }}
      ${import ./config/misc.nix { inherit config userSettings; }}
      ${import ./config/keybindings.nix { inherit config userSettings; }}
      ${import ./config/scratchpads.nix { inherit config userSettings; }}
      ${import ./config/windowrules.nix { inherit config; }}
      ${import ./config/layerrules.nix { inherit config; }}
      ${import ./config/xwayland.nix { inherit config; }}
    '';
    xwayland = { enable = true; };
    systemd.enable = true;
  };

  home.packages = (with pkgs; [
    alacritty
    kitty
    feh
    killall
    polkit_gnome
    nwg-launchers
    papirus-icon-theme
    (pkgs.writeScriptBin "nwggrid-wrapper" ''
      #!/bin/sh
      if pgrep -x "nwggrid-server" > /dev/null
      then
        nwggrid -client
      else
        nwggrid-server &
        sleep 1
        nwggrid -client
      fi
    '')
    (pkgs.writeScriptBin "nwg-dock-wrapper" ''
      #!/bin/sh
      if pgrep -x "nwg-dock" > /dev/null
      then
        nwg-dock -s hyprland
      else
        nwg-dock -s hyprland &
      fi
    '')
  ]);
}
