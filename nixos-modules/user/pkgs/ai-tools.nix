{ config, lib, pkgs, ... }:

{
  imports = [
    # No additional imports needed
  ];

  options = {
    my.packages.aiTools.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable AI and development assistance tools";
    };
  };

  config = lib.mkIf config.my.packages.aiTools.enable {
    home.packages = with pkgs.unstable; [
      # AI related tools
      claude-code
    ];
  };
}