return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = function(_, opts)
    -- Add pomodoro timer to lualine
    table.insert(opts.sections.lualine_x, {
      function()
        local ok, pomo = pcall(require, "pomo")
        if not ok then
          return ""
        end
        
        local timer = pomo.get_first_to_finish()
        if timer == nil then
          return ""
        end
        
        local time_left = pomo.format_time_left(timer)
        local icon = timer.name:match("Work") and "󰄉" or "󰄎"
        
        return string.format("%s %s", icon, time_left)
      end,
      color = function()
        local ok, pomo = pcall(require, "pomo")
        if not ok then
          return nil
        end
        
        local timer = pomo.get_first_to_finish()
        if timer == nil then
          return nil
        end
        
        -- Change color based on timer type and remaining time
        if timer.name:match("Work") then
          return { fg = "#f78c6c" } -- Orange for work
        else
          return { fg = "#89ddff" } -- Blue for break
        end
      end,
      cond = function()
        local ok, pomo = pcall(require, "pomo")
        if not ok then
          return false
        end
        return pomo.get_first_to_finish() ~= nil
      end,
    })
  end,
}
