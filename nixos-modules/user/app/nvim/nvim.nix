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
          binds.whichKey = {
            enable = true;
            register = {
              # Snacks picker keybindings
              "<leader><space>" = "Find Files (Root Dir)";
              "<leader>," = "Buffers";
              "<leader>/" = "Grep (Root Dir)";
              "<leader>:" = "Command History";

              # File operations
              "<leader>e" = "Explorer (root dir)";
              "<leader>E" = "Explorer (cwd)";
              "<leader>f" = "file";
              "<leader>fb" = "Buffers";
              "<leader>fB" = "Buffers (all)";
              "<leader>fc" = "Find Config File";
              "<leader>fe" = "Explorer (root dir)";
              "<leader>fE" = "Explorer (cwd)";
              "<leader>ff" = "Find Files (Root Dir)";
              "<leader>fF" = "Find Files (cwd)";
              "<leader>fg" = "Find Files (git-files)";
              "<leader>fp" = "Projects";
              "<leader>fr" = "Recent";
              "<leader>fR" = "Recent (cwd)";

              # Git operations
              "<leader>g" = "git";
              "<leader>gd" = "Git Diff (hunks)";
              "<leader>gs" = "Git Status";
              "<leader>gS" = "Git Stash";

              # Search operations
              "<leader>s" = "search";
              "<leader>s\"" = "Registers";
              "<leader>s/" = "Search History";
              "<leader>sa" = "Autocmds";
              "<leader>sb" = "Buffer Lines";
              "<leader>sB" = "Grep Open Buffers";
              "<leader>sc" = "Command History";
              "<leader>sC" = "Commands";
              "<leader>sd" = "Diagnostics";
              "<leader>sD" = "Buffer Diagnostics";
              "<leader>sg" = "Grep (Root Dir)";
              "<leader>sG" = "Grep (cwd)";
              "<leader>sh" = "Help Pages";
              "<leader>sH" = "Highlights";
              "<leader>si" = "Icons";
              "<leader>sj" = "Jumps";
              "<leader>sk" = "Keymaps";
              "<leader>sl" = "Location List";
              "<leader>sm" = "Marks";
              "<leader>sM" = "Man Pages";
              "<leader>sp" = "Search for Plugin Spec";
              "<leader>sq" = "Quickfix List";
              "<leader>sR" = "Resume";
              "<leader>su" = "Undotree";
              "<leader>sw" = "Visual selection or word (Root Dir)";
              "<leader>sW" = "Visual selection or word (cwd)";

              # Notifications
              "<leader>n" = "Notification History";

              # UI
              "<leader>u" = "ui";
              "<leader>uC" = "Colorschemes";

              # Obsidian (keeping existing)
              "<leader>o" = "obsidian";
              "<leader>oo" = "Quick Switch Notes";
              "<leader>on" = "New Note";
              "<leader>os" = "Search Notes";
              "<leader>ol" = "Link to Note";
              "<leader>od" = "Today's Note";
              "<leader>oy" = "Yesterday's Note";
              "<leader>ob" = "Show Backlinks";
              "<leader>og" = "Show Tags";
              "<leader>ow" = "Switch Workspace";
              "<leader>of" = "Follow Link";
              "<leader>or" = "Rename Note";
              "<leader>oc" = "Table of Contents";
              "<leader>op" = "Paste Image";
              "<leader>ot" = "Insert Template";

              # Timer (keeping existing)
              "<leader>t" = "timer";
              "<leader>ts" = "Start Work Timer (25min)";
              "<leader>tb" = "Start Break Timer (5min)";
              "<leader>tl" = "Start Long Break (15min)";
              "<leader>tp" = "Pause Timer";
              "<leader>tr" = "Resume Timer";
              "<leader>te" = "Stop Timer";
              "<leader>tt" = "Show Timer Status";
              "<leader>tc" = "Start Pomodoro Session";
              "<leader>th" = "Custom Timer";
            };
          };

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
