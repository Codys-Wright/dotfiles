{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.my.languages.haskell.enable {
    home.packages = with pkgs; [
      haskellPackages.haskell-language-server
      haskellPackages.stack
    ];
  };
}
