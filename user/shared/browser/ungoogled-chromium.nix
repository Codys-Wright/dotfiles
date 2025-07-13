{ pkgs, ... }:

{
  # Module installing ungoogled-chromium browser
  home.packages = [ pkgs.ungoogled-chromium ];

  xdg.mimeApps.defaultApplications = {
    "text/html" = "chromium-browser.desktop";
    "x-scheme-handler/http" = "chromium-browser.desktop";
    "x-scheme-handler/https" = "chromium-browser.desktop";
    "x-scheme-handler/about" = "chromium-browser.desktop";
    "x-scheme-handler/unknown" = "chromium-browser.desktop";
  };

  home.sessionVariables = {
    UNGOOGLED_CHROMIUM = "${pkgs.ungoogled-chromium}/bin/chromium";
  };
} 