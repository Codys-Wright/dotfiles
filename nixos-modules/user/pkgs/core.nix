{
  config,
  lib,
  pkgs,
  ...
}: {
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
    home.packages = with pkgs;
    # Packages available in both stable and unstable (use unstable if enabled)
      (
        if config.my.packages.core.includeUnstable
        then
          (with pkgs.unstable; [
            bat
            bottom
            fd
            ripgrep
            tree
          ])
        else [
          bat
          bottom
          fd
          ripgrep
          tree
        ]
      )
      ++
      # Packages that we always use from stable
      [
        coreutils
        curl
        du-dust
        findutils
        fx
        htop
        jq
        killall
        mosh
        procs
        mprocs
        yazi
        sd
        unzip
        vim
        wget
        zip
      ];
  };
}
