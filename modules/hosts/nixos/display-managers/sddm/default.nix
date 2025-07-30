{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf;

  cfg = config.custom.displayManagers.sddm;
  displayManagerCfg = config.custom.displayManagers;
in
{
  imports = [
    ./themes/astronaut.nix
  ];

    config = mkIf (displayManagerCfg.enable && cfg.enable) {
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      # Theme configuration is handled by individual theme modules
    };

    # Enable theme packages based on selection
    environment.systemPackages = mkIf (cfg.theme == "astronaut") [
      config.custom.sddm.themes.astronaut.package
    ];
  };
}
