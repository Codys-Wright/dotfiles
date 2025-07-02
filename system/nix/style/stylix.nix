{ lib, pkgs, inputs, userSettings, themesPath, ... }:

let
  themeDir = "${themesPath}/${userSettings.theme}";
  themePath = "${themeDir}/${userSettings.theme}.yaml";
  themePolarity = lib.removeSuffix "\n" (builtins.readFile "${themeDir}/polarity.txt");
  myLightDMTheme = if themePolarity == "light" then "Adwaita" else "Adwaita-dark";
  backgroundUrl = builtins.readFile "${themeDir}/backgroundurl.txt";
  backgroundSha256 = builtins.readFile "${themeDir}/backgroundsha256.txt";
in
{
  imports = [ inputs.stylix.nixosModules.stylix ];

  stylix.autoEnable = false;
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

  stylix.targets.lightdm.enable = true;
  services.xserver.displayManager.lightdm = {
      greeters.slick.enable = true;
      greeters.slick.theme.name = myLightDMTheme;
  };
  stylix.targets.console.enable = true;

  environment.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt5ct";
  };

}
