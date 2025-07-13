{ config, lib, pkgs, inputs, userSettings, ... }:

{
  # Enable Neural Amp Modeler LV2 plugin at system level
  environment.systemPackages = with pkgs; [
    neural-amp-modeler-lv2
  ];
} 