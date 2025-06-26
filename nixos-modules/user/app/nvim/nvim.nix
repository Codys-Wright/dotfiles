{
  pkgs,
  nvf,
  ...
}: let
  configModule = {
    config.vim = {
      theme = {
        enable = true;
        name = "gruvbox";
        style = "dark";
      };
      statusline.lualine.enable = true;
      telescope.enable = true;
      autocomplete.nvim-cmp.enable = true;
    };
  };

  customNeovim = nvf.lib.neovimConfiguration {
    inherit pkgs;
    modules = [configModule];
  };
in {
  home.packages = [customNeovim.neovim];
}
