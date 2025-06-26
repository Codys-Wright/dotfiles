{...}: {
  # Base Neovim configuration
  theme = {
    enable = true;
    name = "tokyonight";
    style = "storm";
  };
  
  # Core features
  statusline.lualine.enable = true;
  telescope.enable = true;
  autocomplete.nvim-cmp.enable = true;
  lsp.enable = true;
  treesitter.enable = true;
  
  # Assistant
  assistant = {
    avante-nvim.enable = true;
  };
  
  # Language support
  languages = {
    nix.enable = true;
    ts.enable = true;
    rust.enable = true;
    markdown.enable = true;
    html.enable = true;
    clang.enable = true;
    sql.enable = true;
    lua.enable = true;
    python.enable = true;
  };
}