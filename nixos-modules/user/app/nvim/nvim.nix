{
  pkgs,
  nvf,
  ...
}: let
  customNeovim = nvf.lib.neovimConfiguration {
    pkgs = pkgs.unstable;
    modules = [
      {
        vim = 
          (import ./modules/base.nix {}) //
          (import ./modules/mini.nix {}) //
          (import ./modules/snacks.nix {}) //
          (import ./modules/ui.nix {}) //
          (import ./modules/keymaps.nix {});
      }
    ];
  };
in {
  home.packages = [customNeovim.neovim];
}