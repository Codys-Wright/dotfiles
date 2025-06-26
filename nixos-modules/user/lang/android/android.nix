{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.my.languages.android.enable {
    home.packages = with pkgs; [
      android-tools
      android-udev-rules
    ];
  };
}
