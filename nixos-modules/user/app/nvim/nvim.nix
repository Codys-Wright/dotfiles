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
            setupOpts = {
              preset = "modern";
              win.border = "rounded";
            };
            register = {
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
        };
      }
    ];
  };
in {
  home.packages = [customNeovim.neovim];
}
