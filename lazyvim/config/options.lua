-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Disable annoying auto
vim.g.autoformat = false

-- Set Tabstops
--vim.opt.tabstop = 4
--vim.opt.shiftwidth = 4
--vim.opt.softtabstop = 4
--vim.opt.expandtab = true
--vim.opt.hlsearch = true
--vim.opt.smarttab = false

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.hlsearch = true
vim.opt.smarttab = false

-- Dynamic tab stops
--vim.api.nvim_create_autocmd("FileType", {
--  pattern = { "py" },
--  callback = function()
--    vim.opt.tabstop = 2
--    vim.opt.shiftwidth = 2
--    vim.opt.softtabstop = 2
--  end,
--})

-- 80 char line visual aid

