{ pkgs, ... }:
{
  fonts.fontconfig.enable = true;
  home.packages = builtins.attrValues {
    inherit (pkgs)

      noto-fonts
      meslo-lgs-nf
      ;

    inherit (pkgs.nerd-fonts)

      fira-code
      ;
  };
}
