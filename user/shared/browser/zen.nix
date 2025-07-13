{ pkgs, inputs, ... }:

{
  # Module installing zen-browser
  home.packages = [ inputs.zen-browser.packages.${pkgs.system}.default ];

  xdg.mimeApps.defaultApplications = {
    "text/html" = "zen-browser.desktop";
    "x-scheme-handler/http" = "zen-browser.desktop";
    "x-scheme-handler/https" = "zen-browser.desktop";
    "x-scheme-handler/about" = "zen-browser.desktop";
    "x-scheme-handler/unknown" = "zen-browser.desktop";
  };

  home.sessionVariables = {
    ZEN_BROWSER = "${inputs.zen-browser.packages.${pkgs.system}.default}/bin/zen-browser";
  };
} 