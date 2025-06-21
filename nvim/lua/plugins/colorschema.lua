return {
 
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
  },
  {
    "xiyaowong/transparent.nvim",
    lazy = false, -- Avoid lazy-loading as recommended
    keys = {
      { "<leader>ut", "<cmd>TransparentToggle<cr>", desc = "Toggle Transparency" },
    },
    config = function()
      require("transparent").setup({
        extra_groups = {
          "NormalFloat", -- plugins which have float panel such as Lazy, Mason, LspInfo
          "NvimTreeNormal" -- NvimTree
        },
      })
    end,
  },
    -- Configure LazyVim to load gruvbox
    {
      "LazyVim/LazyVim",
      opts = {
        colorscheme = "catppuccin",
        
      },
    }
  }