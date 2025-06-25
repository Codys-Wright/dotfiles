return {
  "epwalsh/pomo.nvim",
  version = "*",
  lazy = false,
  cmd = { "TimerStart", "TimerRepeat", "TimerSession", "TimerStop", "TimerPause", "TimerResume" },
  dependencies = {
    "rcarriga/nvim-notify",
  },
  opts = {
    update_interval = 1000,
    notifiers = {
      {
        name = "Default",
        opts = {
          sticky = true,
          title_icon = "󱎫",
          text_icon = "󰄉",
        },
      },
      {
        name = "System",
        opts = {
          sticky = false,
          title_icon = "󱎫",
          text_icon = "󰄉",
        },
      },
    },
    sessions = {
      pomodoro = {
        { name = "Work", duration = "25m" },
        { name = "Short Break", duration = "5m" },
        { name = "Work", duration = "25m" },
        { name = "Short Break", duration = "5m" },
        { name = "Work", duration = "25m" },
        { name = "Long Break", duration = "15m" },
      },
    },
    timers = {
      work = {
        { name = "Work", duration = "25m" },
      },
      short_break = {
        { name = "Short Break", duration = "5m" },
      },
      long_break = {
        { name = "Long Break", duration = "15m" },
      },
    },
  },
  keys = {
    { "<leader>ts", function() require("pomo").start_timer(25*60, "Work") end },
    { "<leader>tb", function() require("pomo").start_timer(5*60, "Short Break") end },
    { "<leader>tl", function() require("pomo").start_timer(15*60, "Long Break") end },
    { "<leader>tp", function() require("pomo").pause_timer() end },
    { "<leader>tr", function() require("pomo").resume_timer() end },
    { "<leader>te", function() require("pomo").stop_timer() end },
    { "<leader>tt", function() require("pomo").get_first_to_finish() end },
    { "<leader>tc", "<cmd>TimerSession pomodoro<cr>" },
    { "<leader>th", function()
        vim.ui.input({ prompt = "Timer duration (e.g. 25m, 1h30m): " }, function(duration)
          if duration then
            vim.ui.input({ prompt = "Timer name: " }, function(name)
              if name and duration then
                require("pomo").start_timer(duration, name)
              end
            end)
          end
        end)
      end },
  },
}