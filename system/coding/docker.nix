{ pkgs, lib, userSettings, ... }:

{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    storageDriver = "overlay2";
    autoPrune.enable = true;
  };
  users.users.${userSettings.username}.extraGroups = [ "docker" ];
  environment.systemPackages = with pkgs; [
    docker
    docker-compose
    lazydocker
  ];
}
