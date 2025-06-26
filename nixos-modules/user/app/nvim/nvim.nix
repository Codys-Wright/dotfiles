{
  pkgs,
  nvf,
  ...
}: let
  customNeovim = nvf.lib.neovimConfiguration {
    inherit pkgs;
    modules = [
      {
        vim = {
          theme = {
            enable = true;
            name = "gruvbox";
            style = "dark";
          };
          statusline.lualine.enable = true;
          telescope.enable = true;
          autocomplete.nvim-cmp.enable = true;
        };
      }
    ];
  };
in {
  home.packages = [customNeovim.neovim];
}
