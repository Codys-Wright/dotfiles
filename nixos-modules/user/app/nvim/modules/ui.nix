{...}: {
  # UI Components
  ui.noice = {
    enable = true;
    setupOpts = {
      lsp = {
        override = {
          "vim.lsp.util.convert_input_to_markdown_lines" = true;
          "vim.lsp.util.stylize_markdown" = true;
          "cmp.entry.get_documentation" = true;
        };
      };
      routes = [
        {
          filter = {
            event = "msg_show";
            any = [
              {find = "%d+L, %d+B";}
              {find = "; after #%d+";}
              {find = "; before #%d+";}
            ];
          };
          view = "mini";
        }
      ];
      presets = {
        bottom_search = true;
        command_palette = true;
        long_message_to_split = true;
      };
    };
  };

  # Bufferline/Tabline
  tabline.nvimBufferline = {
    enable = true;
    mappings = {
      closeCurrent = "<leader>bd";
      cycleNext = "<S-l>";
      cyclePrevious = "<S-h>";
      moveNext = "]B";
      movePrevious = "[B";
      pick = "<leader>bc";
      sortByDirectory = "<leader>bsd";
      sortByExtension = "<leader>bse";
      sortById = "<leader>bsi";
    };
    setupOpts = {
      options = {
        close_command = "function(n) require('snacks').bufdelete(n) end";
        right_mouse_command = "function(n) require('snacks').bufdelete(n) end";
        diagnostics = "nvim_lsp";
        always_show_bufferline = false;
        offsets = [
          {
            filetype = "neo-tree";
            text = "Neo-tree";
            highlight = "Directory";
            text_align = "left";
          }
          {
            filetype = "snacks_layout_box";
          }
        ];
      };
    };
  };

  # Which-key keybind helper
  binds.whichKey = {
    enable = true;
    setupOpts = {
      preset = "helix";
    };
    register = {
      # Group definitions
      "<leader><tab>" = "tabs";
      "<leader>c" = "code";
      "<leader>d" = "debug";
      "<leader>dp" = "profiler";
      "<leader>f" = "file/find";
      "<leader>g" = "git";
      "<leader>gh" = "hunks";
      "<leader>q" = "quit/session";
      "<leader>s" = "search";
      "<leader>u" = "ui";
      "<leader>x" = "diagnostics/quickfix";
      "<leader>b" = "buffer";
      "<leader>w" = "windows";
      "[" = "prev";
      "]" = "next";
      "g" = "goto";
      "gs" = "surround";
      "z" = "fold";

      # Better descriptions
      "gx" = "Open with system app";
    };
  };
}
