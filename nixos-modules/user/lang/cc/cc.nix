{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.my.languages.cc.enable {
    home.packages = with pkgs; [
      gcc
      gnumake
      cmake
      autoconf
      automake
      libtool
    ];
  };
}
