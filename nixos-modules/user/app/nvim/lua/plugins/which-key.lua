return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = function(_, opts)
    if opts.spec then
      vim.list_extend(opts.spec, {
        -- Obsidian group
        { "<leader>o", group = "obsidian", icon = "󰠮" },
        { "<leader>oo", desc = "Quick Switch Notes", icon = "󰈆" },
        { "<leader>on", desc = "New Note", icon = "󰝒" },
        { "<leader>os", desc = "Search Notes", icon = "󰍉" },
        { "<leader>ol", desc = "Link to Note", icon = "󰌷" },
        { "<leader>od", desc = "Today's Note", icon = "󰃭" },
        { "<leader>oy", desc = "Yesterday's Note", icon = "󰃯" },
        { "<leader>ob", desc = "Show Backlinks", icon = "󰌷" },
        { "<leader>og", desc = "Show Tags", icon = "󰓹" },
        { "<leader>ow", desc = "Switch Workspace", icon = "󰌽" },
        { "<leader>of", desc = "Follow Link", icon = "󰞘" },
        { "<leader>or", desc = "Rename Note", icon = "󰑕" },
        { "<leader>oc", desc = "Table of Contents", icon = "󰉪" },
        { "<leader>op", desc = "Paste Image", icon = "󰸶" },
        { "<leader>ot", desc = "Insert Template", icon = "󰠮" },
        
        -- Pomodoro Timer group
        { "<leader>t", group = "timer", icon = "󰄉" },
        { "<leader>ts", desc = "Start Work Timer (25min)", icon = "󰐊" },
        { "<leader>tb", desc = "Start Break Timer (5min)", icon = "󰒲" },
        { "<leader>tl", desc = "Start Long Break (15min)", icon = "󰒳" },
        { "<leader>tp", desc = "Pause Timer", icon = "󰏤" },
        { "<leader>tr", desc = "Resume Timer", icon = "󰐊" },
        { "<leader>te", desc = "Stop Timer", icon = "󰓛" },
        { "<leader>tt", desc = "Show Timer Status", icon = "󰔟" },
        { "<leader>tc", desc = "Start Pomodoro Session", icon = "󰄉" },
        { "<leader>th", desc = "Custom Timer", icon = "󰳔" },
      })
    else
      opts.spec = {
        -- Obsidian group
        { "<leader>o", group = "obsidian", icon = "󰠮" },
        { "<leader>oo", desc = "Quick Switch Notes", icon = "󰈆" },
        { "<leader>on", desc = "New Note", icon = "󰝒" },
        { "<leader>os", desc = "Search Notes", icon = "󰍉" },
        { "<leader>ol", desc = "Link to Note", icon = "󰌷" },
        { "<leader>od", desc = "Today's Note", icon = "󰃭" },
        { "<leader>oy", desc = "Yesterday's Note", icon = "󰃯" },
        { "<leader>ob", desc = "Show Backlinks", icon = "󰌷" },
        { "<leader>og", desc = "Show Tags", icon = "󰓹" },
        { "<leader>ow", desc = "Switch Workspace", icon = "󰌽" },
        { "<leader>of", desc = "Follow Link", icon = "󰞘" },
        { "<leader>or", desc = "Rename Note", icon = "󰑕" },
        { "<leader>oc", desc = "Table of Contents", icon = "󰉪" },
        { "<leader>op", desc = "Paste Image", icon = "󰸶" },
        { "<leader>ot", desc = "Insert Template", icon = "󰠮" },
        
        -- Pomodoro Timer group
        { "<leader>t", group = "timer", icon = "󰄉" },
        { "<leader>ts", desc = "Start Work Timer (25min)", icon = "󰐊" },
        { "<leader>tb", desc = "Start Break Timer (5min)", icon = "󰒲" },
        { "<leader>tl", desc = "Start Long Break (15min)", icon = "󰒳" },
        { "<leader>tp", desc = "Pause Timer", icon = "󰏤" },
        { "<leader>tr", desc = "Resume Timer", icon = "󰐊" },
        { "<leader>te", desc = "Stop Timer", icon = "󰓛" },
        { "<leader>tt", desc = "Show Timer Status", icon = "󰔟" },
        { "<leader>tc", desc = "Start Pomodoro Session", icon = "󰄉" },
        { "<leader>th", desc = "Custom Timer", icon = "󰳔" },
      }
    end
  end,
}