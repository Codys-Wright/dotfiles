{ config, lib, pkgs, userSettings, systemSettings, pkgs-nwg-dock-hyprland, ... }:
{
  imports = [
    ../../../coding/app/terminal/alacritty.nix
    ../../../coding/app/terminal/kitty.nix
    (import ../../../shared/dmenu-scripts/networkmanager-dmenu.nix {
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

  wayland.windowManager.hyprland = let
    # Comment out these lines to disable the corresponding modules
    enableEnvironment = false;
    enableAnimations = false;
    enableGeneral = false;
    enableMonitors = false;
    enableInput = false;
    enableDecoration = false;
    enableMisc = false;
    enableKeybindings = false;
    enableScratchpads = false;
    enableWindowrules = false;
    enableLayerrules = false;
    enableXwayland = false;
    
    # Import modules conditionally
    environmentConfig = if enableEnvironment then (import ./config/environment.nix { inherit config pkgs userSettings; }) else "";
    animationsConfig = if enableAnimations then (import ./config/animations.nix { inherit config; }) else "";
    generalConfig = if enableGeneral then (import ./config/general.nix { inherit config; }) else "";
    monitorsConfig = if enableMonitors then (import ./config/monitors.nix { inherit config; }) else "";
    inputConfig = if enableInput then (import ./config/input.nix { inherit config; }) else "";
    decorationConfig = if enableDecoration then (import ./config/decoration.nix { inherit config; }) else "";
    miscConfig = if enableMisc then (import ./config/misc.nix { inherit config userSettings; }) else "";
    keybindingsConfig = if enableKeybindings then (import ./config/keybindings.nix { inherit config userSettings; }) else "";
    scratchpadsConfig = if enableScratchpads then (import ./config/scratchpads.nix { inherit config userSettings; }) else "";
    windowrulesConfig = if enableWindowrules then (import ./config/windowrules.nix { inherit config; }) else "";
    layerrulesConfig = if enableLayerrules then (import ./config/layerrules.nix { inherit config; }) else "";
    xwaylandConfig = if enableXwayland then (import ./config/xwayland.nix { inherit config; }) else "";
  in {
    enable = true;
    plugins = [ ];
    settings = { };
    extraConfig = ''
      # Environment variables
      ${environmentConfig}
      
      # Animations
      ${animationsConfig}
      
      # General settings
      ${generalConfig}
      
      # Monitor configuration
      ${monitorsConfig}
      
      # Input settings
      ${inputConfig}
      
      # Decoration settings
      ${decorationConfig}
      
      # Miscellaneous settings
      ${miscConfig}
      
      # Keybindings
      ${keybindingsConfig}
      
      # Scratchpads
      ${scratchpadsConfig}
      
      # Window rules
      ${windowrulesConfig}
      
      # Layer rules
      ${layerrulesConfig}
      
      # XWayland settings
      ${xwaylandConfig}
      
      # Cursor keybinding
      bind = $mainMod, c, exec, hyprctl setcursor ${pkgs.quintom-cursor-theme}/share/icons/Quintom_Snow/cursors/left_ptr 36
      
      # Waybar configuration
      ${(import ./modules/waybar.nix { inherit config pkgs userSettings; }).waybarExtraConfig}
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
