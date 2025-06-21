return {
  {
    "christoomey/vim-tmux-navigator",
    event = "VeryLazy",
    config = function()
      vim.g.tmux_navigator_no_mappings = 1
    end,
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>", desc = "Go to left window" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>", desc = "Go to lower window" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>", desc = "Go to upper window" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>", desc = "Go to right window" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>", desc = "Go to previous window" },
    },
  }
}