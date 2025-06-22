{ config, lib, pkgs, ... }:

{
  imports = [
    # No additional imports needed
  ];

  options = {
    my.packages.core.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable core CLI utilities package collection";
    };

    my.packages.core.includeUnstable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Include bleeding-edge versions of core utilities";
    };
  };

  config = lib.mkIf config.my.packages.core.enable {
    home.packages = with pkgs; [
      # Essential CLI utilities
      bat
      bottom
      coreutils
      curl
      du-dust
      fd
      findutils
      fx
      htop
      jq
      killall
      mosh
      procs
      mprocs
      yazi
      ripgrep
      sd
      tree
      unzip
      vim
      wget
      zip
    ] ++ lib.optionals config.my.packages.core.includeUnstable (with pkgs.unstable; [
      # Bleeding-edge versions when available
      bat
      bottom
      fd
      ripgrep
      tree
    ]);
  };
}