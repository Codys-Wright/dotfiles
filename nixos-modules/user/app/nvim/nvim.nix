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

          # Custom keymaps for snacks
          keymaps = [
            {
              key = "<leader><space>";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.smart()<CR>";
              silent = true;
              desc = "Smart Find Files";
            }
            {
              key = "<leader>e";
              mode = ["n"];
              action = "<cmd>lua Snacks.explorer()<CR>";
              silent = true;
              desc = "Explorer (root dir)";
            }
            {
              key = "<leader>ff";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.files()<CR>";
              silent = true;
              desc = "Find Files";
            }
            {
              key = "<leader>fg";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.git_files()<CR>";
              silent = true;
              desc = "Find Git Files";
            }
            {
              key = "<leader>fr";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.recent()<CR>";
              silent = true;
              desc = "Recent Files";
            }
            {
              key = "<leader>/";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.grep()<CR>";
              silent = true;
              desc = "Grep";
            }
            {
              key = "<leader>,";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.buffers()<CR>";
              silent = true;
              desc = "Buffers";
            }
          ];

          # Snacks.nvim utility collection
          utility.snacks-nvim = {
            enable = true;
            setupOpts = {
              picker = true;
              explorer = true;
              dashboard = true;
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
