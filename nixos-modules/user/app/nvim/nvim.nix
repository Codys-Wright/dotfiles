{
  pkgs,
  nvf,
  ...
}: let
  configModule = {
    config.vim = {
      # Minimal configuration - no theme for now
    };
  };

  customNeovim = nvf.lib.neovimConfiguration {
    inherit pkgs;
    modules = [configModule];
  };
in {
  home.packages = [customNeovim.neovim];
}
