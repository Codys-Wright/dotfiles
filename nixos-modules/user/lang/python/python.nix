{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.my.languages.python.enable {
    home.packages = with pkgs; 
      [python3Full]
      ++ lib.optionals config.my.languages.python.includePackages [
        imath
        pystring
      ];
  };
}
