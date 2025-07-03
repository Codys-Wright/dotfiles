{ lib, pkgs, inputs, userSettings, themesDir, ... }:

let
  themePath = "${themesDir}/${userSettings.theme}/${userSettings.theme}.yaml";
  themePolarity = lib.removeSuffix "\n" (builtins.readFile "${themesDir}/${userSettings.theme}/polarity.txt");
  myLightDMTheme = if themePolarity == "light" then "Adwaita" else "Adwaita-dark";
  backgroundUrl = builtins.readFile "${themesDir}/${userSettings.theme}/backgroundurl.txt";
  backgroundSha256 = builtins.readFile "${themesDir}/${userSettings.theme}/backgroundsha256.txt";
in
{
  imports = [ inputs.stylix.nixosModules.stylix ];

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
      name = "Noto Color Emoji";
      package = pkgs.noto-fonts-emoji-blob-bin;
    };
  };

  # System-level targets for comprehensive theming
  stylix.targets.lightdm.enable = true;
  stylix.targets.console.enable = true;
  stylix.targets.gtk.enable = true;
  stylix.targets.qt.enable = true;
  
  services.xserver.displayManager.lightdm = {
      greeters.slick.enable = true;
      greeters.slick.theme.name = myLightDMTheme;
  };

  environment.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt5ct";
  };

}
