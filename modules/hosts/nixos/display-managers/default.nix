{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkOption
    mkEnableOption
    types
    mkIf
    ;

  cfg = config.custom.displayManagers;
in
{
  options.custom.displayManagers = {
    enable = mkEnableOption "custom display manager configurations";

    sddm = {
      enable = mkEnableOption "SDDM display manager";

      theme = mkOption {
        type = types.enum [
          "astronaut"
          "breeze"
          "maldives"
        ];
        default = "astronaut";
        description = "SDDM theme to use";
      };
    };
  };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      displayManager.sddm = mkIf cfg.sddm.enable {
        enable = true;
        theme = cfg.sddm.theme;
      };
    };

    # Import theme-specific configurations
    imports = [
      ./sddm
    ];
  };
}
