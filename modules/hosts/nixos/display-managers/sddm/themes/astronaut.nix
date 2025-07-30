{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf mkOption types;

  cfg = config.custom.displayManagers.sddm;

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

  config = mkIf (cfg.enable && cfg.theme == "astronaut") {
    # Add any theme-specific configuration here
    services.xserver.displayManager.sddm.settings = {
      Theme = {
        Current = "sddm-astronaut-theme";
      };
    };
  };
}
