return {
    {
        "m4xshen/hardtime.nvim",
        lazy = false,
        dependencies = { "MunifTanjim/nui.nvim" },
        opts = {
            showmode = false, -- Disable showmode to prevent conflicts with statusline
            notification = true, -- Enable notifications
            disabled_mouse = false, -- Keep mouse enabled
            hint = true, -- Show hints
            allow_different_key = false, -- Don't allow different keys for same action
            enabled = true, -- Enable the plugin
        },
        config = function(_, opts)
            require("hardtime").setup(opts)
            vim.opt.cmdheight = 2 -- Ensure hint messages don't get replaced
        end
    },
   --  {
   --      "tris203/precognition.nvim",
   --      lazy = false,
   --      opts = {
   --          -- startVisible = true,
   --          -- showBlankVirtLine = true,
   --          -- highlightColor = { link = "Comment" },
   --          -- hints = {
   --          --      Caret = { text = "^", prio = 2 },
   --          --      Dollar = { text = "$", prio = 1 },
   --          --      MatchingPair = { text = "%", prio = 5 },
   --          --      Zero = { text = "0", prio = 1 },
   --          --      w = { text = "w", prio = 10 },
   --          --      b = { text = "b", prio = 9 },
   --          --      e = { text = "e", prio = 8 },
   --          --      W = { text = "W", prio = 7 },
   --          --      B = { text = "B", prio = 6 },
   --          --      E = { text = "E", prio = 5 },
   --          -- },
   --          -- gutterHints = {
   --          --     G = { text = "G", prio = 9 },
   --          --     gg = { text = "gg", prio = 9 },
   --          --     PrevParagraph = { text = "{", prio = 8 },
   --          --     NextParagraph = { text = "}", prio = 8 },
   --          -- },
   --          -- disabled_fts = {
   --          --     "startify",
   --          -- },
   --      }
   --  }
}
