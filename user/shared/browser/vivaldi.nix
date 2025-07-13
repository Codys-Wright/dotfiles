{ pkgs, ... }:

{
  # Module installing vivaldi browser
  home.packages = [ pkgs.vivaldi ];

  xdg.mimeApps.defaultApplications = {
    "text/html" = "vivaldi-stable.desktop";
    "x-scheme-handler/http" = "vivaldi-stable.desktop";
    "x-scheme-handler/https" = "vivaldi-stable.desktop";
    "x-scheme-handler/about" = "vivaldi-stable.desktop";
    "x-scheme-handler/unknown" = "vivaldi-stable.desktop";
  };

  home.sessionVariables = {
    VIVALDI_BROWSER = "${pkgs.vivaldi}/bin/vivaldi";
  };
} 