return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
    "nvim-telescope/telescope.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    workspaces = {
      {
        name = "personal",
        path = "/mnt/c/Users/Cody/Documents/Second-Brain/",
      },
      {
        name = "work",
        path = "~/vaults/work",
      },
    },

    daily_notes = {
      folder = "dailies",
      date_format = "%Y-%m-%d",
      alias_format = "%B %-d, %Y",
      default_tags = { "daily-notes" },
      template = nil,
    },

    completion = {
      nvim_cmp = true,
      min_chars = 2,
    },

    new_notes_location = "notes_subdir",
    notes_subdir = "notes",

    note_id_func = function(title)
      local suffix = ""
      if title ~= nil then
        suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      else
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
      end
      return tostring(os.time()) .. "-" .. suffix
    end,

    wiki_link_func = "use_alias_only",

    preferred_link_style = "wiki",

    disable_frontmatter = false,

    templates = {
      folder = "templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
      substitutions = {},
    },

    ui = {
      enable = true,
      update_debounce = 200,
      max_file_length = 5000,
      checkboxes = {
        [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
        ["x"] = { char = "", hl_group = "ObsidianDone" },
        [">"] = { char = "", hl_group = "ObsidianRightArrow" },
        ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
        ["!"] = { char = "", hl_group = "ObsidianImportant" },
      },
      bullets = { char = "•", hl_group = "ObsidianBullet" },
      external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
      reference_text = { hl_group = "ObsidianRefText" },
      highlight_text = { hl_group = "ObsidianHighlightText" },
      tags = { hl_group = "ObsidianTag" },
      block_ids = { hl_group = "ObsidianBlockID" },
      hl_groups = {
        ObsidianTodo = { bold = true, fg = "#f78c6c" },
        ObsidianDone = { bold = true, fg = "#89ddff" },
        ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
        ObsidianTilde = { bold = true, fg = "#ff5370" },
        ObsidianImportant = { bold = true, fg = "#d73128" },
        ObsidianBullet = { bold = true, fg = "#89ddff" },
        ObsidianRefText = { underline = true, fg = "#c792ea" },
        ObsidianExtLinkIcon = { fg = "#c792ea" },
        ObsidianTag = { italic = true, fg = "#89ddff" },
        ObsidianBlockID = { italic = true, fg = "#89ddff" },
        ObsidianHighlightText = { bg = "#75662e" },
      },
    },

    attachments = {
      img_folder = "assets/imgs",
      img_text_func = function(client, path)
        path = client:vault_relative_path(path) or path
        return string.format("![%s](%s)", path.name, path)
      end,
    },
  },

  keys = {
    { "<leader>oo", "<cmd>ObsidianQuickSwitch<cr>", desc = "Quick Switch Notes" },
    { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "New Note" },
    { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Search Notes" },
    { "<leader>ol", "<cmd>ObsidianLink<cr>", desc = "Link to Note", mode = "v" },
    { "<leader>od", "<cmd>ObsidianToday<cr>", desc = "Today's Note" },
    { "<leader>oy", "<cmd>ObsidianYesterday<cr>", desc = "Yesterday's Note" },
    { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Show Backlinks" },
    { "<leader>og", "<cmd>ObsidianTags<cr>", desc = "Show Tags" },
    { "<leader>ow", "<cmd>ObsidianWorkspace<cr>", desc = "Switch Workspace" },
    { "<leader>of", "<cmd>ObsidianFollowLink<cr>", desc = "Follow Link" },
    { "<leader>or", "<cmd>ObsidianRename<cr>", desc = "Rename Note" },
    { "<leader>oc", "<cmd>ObsidianTOC<cr>", desc = "Table of Contents" },
    { "<leader>op", "<cmd>ObsidianPasteImg<cr>", desc = "Paste Image" },
    { "<leader>ot", "<cmd>ObsidianTemplate<cr>", desc = "Insert Template" },
    { "gf", function()
        if require("obsidian").util.cursor_on_markdown_link() then
          return "<cmd>ObsidianFollowLink<CR>"
        else
          return "gf"
        end
      end, noremap = false, expr = true, desc = "Follow Link or File" },
  },
}
