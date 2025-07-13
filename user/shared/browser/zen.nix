{ pkgs, ... }:

{
  # Module installing zen-browser
  home.packages = [ pkgs.zen-browser ];

  xdg.mimeApps.defaultApplications = {
    "text/html" = "zen-browser.desktop";
    "x-scheme-handler/http" = "zen-browser.desktop";
    "x-scheme-handler/https" = "zen-browser.desktop";
    "x-scheme-handler/about" = "zen-browser.desktop";
    "x-scheme-handler/unknown" = "zen-browser.desktop";
  };

  home.sessionVariables = {
    ZEN_BROWSER = "${pkgs.zen-browser}/bin/zen-browser";
  };
} 