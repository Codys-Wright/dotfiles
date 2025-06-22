{ config, lib, pkgs, ... }:

{
  imports = [
    # No additional imports needed
  ];

  options = {
    my.packages.nixTools.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Nix development and maintenance tools";
    };
  };

  config = lib.mkIf config.my.packages.nixTools.enable {
    home.packages = with pkgs; [
      # Nix formatters and linters
      alejandra # Nix formatter
      deadnix # Remove unused Nix code
      statix # Nix linter
    ];
  };
}