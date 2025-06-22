{ config, lib, pkgs, ... }:

{
  imports = [
    # No additional imports needed for this module
  ];

  options = {
    my.gitui.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable gitui terminal git interface";
    };

    my.gitui.package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.gitui;
      description = "The gitui package to use";
    };
  };

  config = {
    programs.gitui = {
      enable = config.my.gitui.enable;
      package = config.my.gitui.package;
    };
  };
}