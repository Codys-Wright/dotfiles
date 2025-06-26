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
            # Top Pickers & Explorer
            {
              key = "<leader><space>";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.smart()<CR>";
              silent = true;
              desc = "Smart Find Files";
            }
            {
              key = "<leader>,";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.buffers()<CR>";
              silent = true;
              desc = "Buffers";
            }
            {
              key = "<leader>/";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.grep()<CR>";
              silent = true;
              desc = "Grep";
            }
            {
              key = "<leader>:";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.command_history()<CR>";
              silent = true;
              desc = "Command History";
            }
            {
              key = "<leader>e";
              mode = ["n"];
              action = "<cmd>lua Snacks.explorer()<CR>";
              silent = true;
              desc = "File Explorer";
            }

            # Find
            {
              key = "<leader>fb";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.buffers()<CR>";
              silent = true;
              desc = "Buffers";
            }
            {
              key = "<leader>fc";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.files({ cwd = vim.fn.stdpath('config') })<CR>";
              silent = true;
              desc = "Find Config File";
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
              key = "<leader>fp";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.projects()<CR>";
              silent = true;
              desc = "Projects";
            }
            {
              key = "<leader>fr";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.recent()<CR>";
              silent = true;
              desc = "Recent";
            }

            # Git
            {
              key = "<leader>gb";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.git_branches()<CR>";
              silent = true;
              desc = "Git Branches";
            }
            {
              key = "<leader>gl";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.git_log()<CR>";
              silent = true;
              desc = "Git Log";
            }
            {
              key = "<leader>gL";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.git_log_line()<CR>";
              silent = true;
              desc = "Git Log Line";
            }
            {
              key = "<leader>gs";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.git_status()<CR>";
              silent = true;
              desc = "Git Status";
            }
            {
              key = "<leader>gS";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.git_stash()<CR>";
              silent = true;
              desc = "Git Stash";
            }
            {
              key = "<leader>gd";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.git_diff()<CR>";
              silent = true;
              desc = "Git Diff (Hunks)";
            }
            {
              key = "<leader>gf";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.git_log_file()<CR>";
              silent = true;
              desc = "Git Log File";
            }

            # Search
            {
              key = "<leader>s\"";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.registers()<CR>";
              silent = true;
              desc = "Registers";
            }
            {
              key = "<leader>s/";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.search_history()<CR>";
              silent = true;
              desc = "Search History";
            }
            {
              key = "<leader>sa";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.autocmds()<CR>";
              silent = true;
              desc = "Autocmds";
            }
            {
              key = "<leader>sb";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.lines()<CR>";
              silent = true;
              desc = "Buffer Lines";
            }
            {
              key = "<leader>sB";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.grep_buffers()<CR>";
              silent = true;
              desc = "Grep Open Buffers";
            }
            {
              key = "<leader>sc";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.command_history()<CR>";
              silent = true;
              desc = "Command History";
            }
            {
              key = "<leader>sC";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.commands()<CR>";
              silent = true;
              desc = "Commands";
            }
            {
              key = "<leader>sd";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.diagnostics()<CR>";
              silent = true;
              desc = "Diagnostics";
            }
            {
              key = "<leader>sD";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.diagnostics_buffer()<CR>";
              silent = true;
              desc = "Buffer Diagnostics";
            }
            {
              key = "<leader>sg";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.grep()<CR>";
              silent = true;
              desc = "Grep";
            }
            {
              key = "<leader>sh";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.help()<CR>";
              silent = true;
              desc = "Help Pages";
            }
            {
              key = "<leader>sH";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.highlights()<CR>";
              silent = true;
              desc = "Highlights";
            }
            {
              key = "<leader>si";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.icons()<CR>";
              silent = true;
              desc = "Icons";
            }
            {
              key = "<leader>sj";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.jumps()<CR>";
              silent = true;
              desc = "Jumps";
            }
            {
              key = "<leader>sk";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.keymaps()<CR>";
              silent = true;
              desc = "Keymaps";
            }
            {
              key = "<leader>sl";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.loclist()<CR>";
              silent = true;
              desc = "Location List";
            }
            {
              key = "<leader>sm";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.marks()<CR>";
              silent = true;
              desc = "Marks";
            }
            {
              key = "<leader>sM";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.man()<CR>";
              silent = true;
              desc = "Man Pages";
            }
            {
              key = "<leader>sp";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.lazy()<CR>";
              silent = true;
              desc = "Search for Plugin Spec";
            }
            {
              key = "<leader>sq";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.qflist()<CR>";
              silent = true;
              desc = "Quickfix List";
            }
            {
              key = "<leader>sR";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.resume()<CR>";
              silent = true;
              desc = "Resume";
            }
            {
              key = "<leader>su";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.undo()<CR>";
              silent = true;
              desc = "Undo History";
            }
            {
              key = "<leader>sw";
              mode = ["n" "x"];
              action = "<cmd>lua Snacks.picker.grep_word()<CR>";
              silent = true;
              desc = "Visual selection or word";
            }
            {
              key = "<leader>uC";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.colorschemes()<CR>";
              silent = true;
              desc = "Colorschemes";
            }

            # LSP
            {
              key = "gd";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.lsp_definitions()<CR>";
              silent = true;
              desc = "Goto Definition";
            }
            {
              key = "gD";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.lsp_declarations()<CR>";
              silent = true;
              desc = "Goto Declaration";
            }
            {
              key = "gr";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.lsp_references()<CR>";
              silent = true;
              desc = "References";
            }
            {
              key = "gI";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.lsp_implementations()<CR>";
              silent = true;
              desc = "Goto Implementation";
            }
            {
              key = "gy";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.lsp_type_definitions()<CR>";
              silent = true;
              desc = "Goto T[y]pe Definition";
            }
            {
              key = "<leader>ss";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.lsp_symbols()<CR>";
              silent = true;
              desc = "LSP Symbols";
            }
            {
              key = "<leader>sS";
              mode = ["n"];
              action = "<cmd>lua Snacks.picker.lsp_workspace_symbols()<CR>";
              silent = true;
              desc = "LSP Workspace Symbols";
            }

            # Other
            {
              key = "<leader>z";
              mode = ["n"];
              action = "<cmd>lua Snacks.zen()<CR>";
              silent = true;
              desc = "Toggle Zen Mode";
            }
            {
              key = "<leader>Z";
              mode = ["n"];
              action = "<cmd>lua Snacks.zen.zoom()<CR>";
              silent = true;
              desc = "Toggle Zoom";
            }
            {
              key = "<leader>.";
              mode = ["n"];
              action = "<cmd>lua Snacks.scratch()<CR>";
              silent = true;
              desc = "Toggle Scratch Buffer";
            }
            {
              key = "<leader>S";
              mode = ["n"];
              action = "<cmd>lua Snacks.scratch.select()<CR>";
              silent = true;
              desc = "Select Scratch Buffer";
            }
            {
              key = "<leader>bd";
              mode = ["n"];
              action = "<cmd>lua Snacks.bufdelete()<CR>";
              silent = true;
              desc = "Delete Buffer";
            }
            {
              key = "<leader>cR";
              mode = ["n"];
              action = "<cmd>lua Snacks.rename.rename_file()<CR>";
              silent = true;
              desc = "Rename File";
            }
            {
              key = "<leader>gB";
              mode = ["n" "v"];
              action = "<cmd>lua Snacks.gitbrowse()<CR>";
              silent = true;
              desc = "Git Browse";
            }
            {
              key = "<leader>gg";
              mode = ["n"];
              action = "<cmd>lua Snacks.lazygit()<CR>";
              silent = true;
              desc = "Lazygit";
            }
            {
              key = "<leader>un";
              mode = ["n"];
              action = "<cmd>lua Snacks.notifier.hide()<CR>";
              silent = true;
              desc = "Dismiss All Notifications";
            }
            {
              key = "<c-/>";
              mode = ["n"];
              action = "<cmd>lua Snacks.terminal()<CR>";
              silent = true;
              desc = "Toggle Terminal";
            }
            {
              key = "<c-_>";
              mode = ["n"];
              action = "<cmd>lua Snacks.terminal()<CR>";
              silent = true;
              desc = "Toggle Terminal";
            }
            {
              key = "]]";
              mode = ["n" "t"];
              action = "<cmd>lua Snacks.words.jump(vim.v.count1)<CR>";
              silent = true;
              desc = "Next Reference";
            }
            {
              key = "[[";
              mode = ["n" "t"];
              action = "<cmd>lua Snacks.words.jump(-vim.v.count1)<CR>";
              silent = true;
              desc = "Prev Reference";
            }
          ];

          # Snacks.nvim utility collection
          utility.snacks-nvim = {
            enable = true;
            setupOpts = {
              bigfile = {enabled = true;};
              dashboard = {enabled = false;}; # Disable dashboard to avoid lazy.nvim dependency
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
