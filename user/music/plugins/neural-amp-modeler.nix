{ config, lib, pkgs, userSettings, ... }:

{
  # Enable Neural Amp Modeler LV2 plugin
  home.packages = with pkgs; [
    neural-amp-modeler-lv2
  ];

  # Configure LV2_PATH to include the neural-amp-modeler plugin
  home.sessionVariables = {
    LV2_PATH = "$LV2_PATH:${pkgs.neural-amp-modeler-lv2}/lib/lv2";
  };
} 