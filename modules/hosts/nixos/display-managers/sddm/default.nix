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
    services.xserver.displayManager.sddm = {
      enable = true;
      wayland.enable = true;

      # Configure theme based on selection
      theme = mkIf (cfg.theme == "astronaut") "sddm-astronaut-theme";
    };

    # Enable theme packages based on selection
    environment.systemPackages = mkIf (cfg.theme == "astronaut") [
      config.custom.sddm.themes.astronaut.package
    ];
  };
}
