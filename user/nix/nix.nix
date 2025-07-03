{ config, pkgs, ... }:

{
  imports = [
    ./style/stylix.nix
    # ./wm/hyprland/hyprland.nix
    # ./wm/input/nihongo.nix
  ];


programs.kitty.enable = true; 
wayland.windowManager.hyprland.enable = true;

wayland.windowManager.hyprland.settings = {

	"$mod" = "SUPER";
	bind = [

		"$mod, F, exec, brave"
		"$mod, c, exec, cursor"
	];

};

home.sessionVariables.NIXOS_OZONE_WL = "1";
  # Additional core user configurations can go here
  # These should be configurations that are needed in every profile
  # For example, basic user settings, core keybindings, etc.
} 
