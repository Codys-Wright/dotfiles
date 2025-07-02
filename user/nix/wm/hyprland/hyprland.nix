{ config, lib, pkgs, userSettings, systemSettings, pkgs-nwg-dock-hyprland, ... }:
{

	wayland.windowManager.hyprland = {
enable = true;
settings = {

	"$fileManager" = "dolphin";
	"$mainMod" = "SUPER";

	bind = [
		"$mainMod, q, kitty"
		"$mainMod, RETURN, exec, kitty"
		"$mainMod, B, exec, firefox"
		"$mainMod, E, exec, dolphin"
	];

};
	};



  
  }

