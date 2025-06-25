{
  config,
  pkgs,
  ...
}: {
  programs.neovim = {
    enable = true;
    package = pkgs.unstable.neovim-unwrapped;

    withNodeJs = true;
    withPython3 = true;
    withRuby = true;

    extraPackages = with pkgs; [
      nil # Nix language server
      nodePackages.vscode-langservers-extracted
      nodePackages.yaml-language-server
      tree-sitter
      ripgrep # Required for Obsidian search functionality
      stylua # Lua formatter
    ];
  };

  # Configure nvim config files
  xdg.configFile."nvim/init.lua" = {
    source = ./init.lua;
  };
  xdg.configFile."nvim/lua" = {
    source = ./lua;
    recursive = true;
  };
}
