{
  pkgs,
  nvf,
  ...
}: let
  customNeovim = nvf.lib.neovimConfiguration {
    pkgs = pkgs.unstable;
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

          # Mini plugins
          mini = {
            surround.enable = true;
            pairs.enable = true;
            files.enable = true;
            pick.enable = true;
            comment.enable = true;
            indentscope.enable = true;
            cursorword.enable = true;
            hipatterns.enable = true;
            icons.enable = true;
          };

          # Which-key keybind helper
          binds.whichKey.enable = true;

          # Snacks.nvim utility collection
          utility.snacks-nvim = {
            enable = true;
            setupOpts = {
              bigfile = {enabled = true;};
              dashboard = {enabled = true;};
              explorer = {enabled = true;};
              indent = {enabled = true;};
              input = {enabled = true;};
              picker = {enabled = true;};
              notifier = {enabled = true;};
              quickfile = {enabled = true;};
              scope = {enabled = true;};
              scroll = {enabled = true;};
              statuscolumn = {enabled = true;};
              words = {enabled = true;};
            };
          };

          assistant = {
            avante-nvim.enable = true;
          };

          lsp.enable = true;
          treesitter.enable = true;

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
        };
      }
    ];
  };
in {
  home.packages = [customNeovim.neovim];
}
