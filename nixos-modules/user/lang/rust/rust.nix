{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.my.languages.rust.enable {
    home.packages = with pkgs; [
      rustup
    ];
  };
}
