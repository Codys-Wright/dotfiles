-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Disable default 's' behavior and show WhichKey
vim.keymap.set('n', 's', function()
  require('which-key').show('s', { mode = 'n', auto = true })
end, { desc = 'Show WhichKey for s mappings' })

-- Remap scroll functions
vim.keymap.set('n', '<C-u>', '<C-d>', { noremap = true, silent = true, desc = 'Scroll down' })
vim.keymap.set('n', '<C-i>', '<C-u>', { noremap = true, silent = true, desc = 'Scroll up' })

-- Duplicate current line below
vim.keymap.set('n', '<C-d>', 'yyp', { noremap = true, silent = true, desc = 'Duplicate line below' })

 