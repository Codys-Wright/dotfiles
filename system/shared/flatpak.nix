{ pkgs, ... }:

{
  # Need some flatpaks
  services.flatpak.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [
  ];
}
