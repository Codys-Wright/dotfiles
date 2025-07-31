{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf mkOption types;

  cfg = config.custom.displayManagers.sddm;
  displayManagerCfg = config.custom.displayManagers;

  # Fetch the astronaut theme from GitHub
  sddm-astronaut-theme = pkgs.fetchFromGitHub {
    owner = "Keyitdev";
    repo = "sddm-astronaut-theme";
    rev = "3ef9f511fd072ff3dbb6eb3c1c499a71f338967e";
    sha256 = "sha256-33CzZ4vK1dicVzICbudk8gSRC/MExG+WnrE9wIWET14=";
  };

  # Package the theme for SDDM
  astronaut-theme-package = pkgs.stdenv.mkDerivation {
    pname = "sddm-astronaut-theme";
    version = "unstable";

    src = sddm-astronaut-theme;

    installPhase = ''
      mkdir -p $out/share/sddm/themes/sddm-astronaut-theme
      cp -r * $out/share/sddm/themes/sddm-astronaut-theme/
    '';

    meta = with lib; {
      description = "Astronaut theme for SDDM";
      homepage = "https://github.com/Keyitdev/sddm-astronaut-theme";
      license = licenses.gpl3;
      platforms = platforms.linux;
    };
  };
in
{
  options.custom.sddm.themes.astronaut = {
    package = mkOption {
      type = types.package;
      default = astronaut-theme-package;
      description = "The astronaut theme package for SDDM";
    };
  };

  config = mkIf (displayManagerCfg.enable && cfg.enable && cfg.theme == "astronaut") {
    # Set the SDDM theme to the astronaut theme
    services.displayManager.sddm.theme = "sddm-astronaut-theme";
    
    # Add required Qt multimedia components for the astronaut theme
    environment.systemPackages = with pkgs; [
      pkgs.unstable.kdePackages.qtmultimedia
      pkgs.unstable.qt5.qtquickcontrols2
      pkgs.unstable.qt5.qtgraphicaleffects
    ];
  };
}
