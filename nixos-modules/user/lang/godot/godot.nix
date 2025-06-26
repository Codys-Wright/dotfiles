{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.my.languages.godot.enable {
    home.packages = with pkgs; [
      godot_4
    ];
  };
}
