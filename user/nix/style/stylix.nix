{ config, lib, pkgs, inputs, userSettings, ... }:

let
  themePath = "${inputs.self.outPath}/themes/${userSettings.theme}/${userSettings.theme}.yaml";
  themePolarity = lib.removeSuffix "\n" (builtins.readFile "${inputs.self.outPath}/themes/${userSettings.theme}/polarity.txt");
  backgroundUrl = builtins.readFile "${inputs.self.outPath}/themes/${userSettings.theme}/backgroundurl.txt";
  backgroundSha256 = builtins.readFile "${inputs.self.outPath}/themes/${userSettings.theme}/backgroundsha256.txt";
in
{
  imports = [ inputs.stylix.homeModules.stylix ];

  home.file.".currenttheme".text = userSettings.theme;
  stylix.autoEnable = true;
  stylix.polarity = themePolarity;
  stylix.image = pkgs.fetchurl {
    url = backgroundUrl;
    sha256 = backgroundSha256;
  };
  stylix.base16Scheme = themePath;

  stylix.fonts = {
    monospace = {
      name = userSettings.font;
      package = userSettings.fontPkg;
    };
    serif = {
      name = userSettings.font;
      package = userSettings.fontPkg;
    };
    sansSerif = {
      name = userSettings.font;
      package = userSettings.fontPkg;
    };
    emoji = {
      name = "Noto Emoji";
      package = pkgs.noto-fonts-monochrome-emoji;
    };
    sizes = {
      terminal = 18;
      applications = 12;
      popups = 12;
      desktop = 12;
    };
  };

  # Only keep customizations not handled by stylix autoEnable
  programs.feh.enable = true;
  home.file.".fehbg-stylix".text = ''
    #!/bin/sh
    feh --no-fehbg --bg-fill ''+config.stylix.image+'';
  '';
  home.file.".fehbg-stylix".executable = true;
  home.file = {
    ".config/qt5ct/colors/oomox-current.conf".source = config.lib.stylix.colors {
      template = builtins.readFile (./. + "/oomox-current.conf.mustache");
      extension = ".conf";
    };
    ".config/Trolltech.conf".source = config.lib.stylix.colors {
      template = builtins.readFile (./. + "/Trolltech.conf.mustache");
      extension = ".conf";
    };
    ".config/kdeglobals".source = config.lib.stylix.colors {
      template = builtins.readFile (./. + "/Trolltech.conf.mustache");
      extension = "";
    };
    ".config/qt5ct/qt5ct.conf".text = pkgs.lib.mkBefore (builtins.readFile (./. + "/qt5ct.conf"));
  };
  home.file.".config/hypr/hyprpaper.conf".text = ''
    preload = ''+config.stylix.image+''

    wallpaper = ,''+config.stylix.image+''

  '';

  gtk.cursorTheme = {
    package = pkgs.quintom-cursor-theme;
    name = if (config.stylix.polarity == "light") then "Quintom_Ink" else "Quintom_Snow";
    size = 36;
  };
  home.packages = with pkgs; [
     libsForQt5.qt5ct pkgs.libsForQt5.breeze-qt5 pkgs.noto-fonts-monochrome-emoji
     quintom-cursor-theme
  ];
  qt = {
    enable = true;
    style.package = pkgs.libsForQt5.breeze-qt5;
    style.name = "breeze-dark";
    platformTheme = "kde";
  };
  fonts.fontconfig.defaultFonts = {
    monospace = [ userSettings.font ];
    sansSerif = [ userSettings.font ];
    serif = [ userSettings.font ];
  };
}
