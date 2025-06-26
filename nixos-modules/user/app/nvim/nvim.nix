{
  pkgs,
  nvf,
  ...
}: let
  configModule = {
    config.vim = {
      theme.enable = true;
      # and more options as you see fit...
    };
  };

  customNeovim = nvf.lib.neovimConfiguration {
    inherit pkgs;
    modules = [configModule];
  };
in {
  home.packages = [customNeovim.neovim];
}
