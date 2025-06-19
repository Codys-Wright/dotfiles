return {
  -- disable the default <leader>sa keybinding from LazyVim
  {
    "LazyVim/LazyVim",
    keys = {
      { "<leader>sa", false },
    },
  },
  -- disable the default <leader>sd from fzf-lua
  {
    "ibhagwan/fzf-lua",
    keys = {
      { "<leader>sd", false },
    },
  },
  -- configure mini.surround
  {
    "echasnovski/mini.surround",
    keys = {
      { "<leader>sa", desc = "Add surrounding" },
      { "<leader>sd", desc = "Delete surrounding" },
    },
    opts = {
      mappings = {
        add = "<leader>sa",
        delete = "<leader>sd",
        find = "gsf",
        find_left = "gsF",
        highlight = "gsh",
        replace = "gsr",
        update_n_lines = "gsn",
      },
    },
  },
}

