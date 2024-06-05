-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Remove annoying commands

-- windows

-- tabs
vim.keymap.del("n", "<leader><tab><tab>")
vim.keymap.set("n", "<leader>tn", "<cmd>tabnew<cr>",
  { desc = "New Tab" })
vim.keymap.del("n", "<leader><tab>d")
vim.keymap.set("n", "<leader>td", "<cmd>tabclose<cr>",
  { desc = "Close Tab" })
vim.keymap.del("n", "<leader><tab>o")
vim.keymap.set("n", "<leader>to", "<cmd>tabonly<cr>",
  { desc = "Close Other Tabs" })

vim.keymap.del("n", "<leader><tab>]")
vim.keymap.set("n", "<leader>t]", "<cmd>tabnext<cr>",
  { desc = "Next Tab" })
vim.keymap.del("n", "<leader><tab>[")
vim.keymap.set("n", "<leader>t[", "<cmd>tabprevious<cr>",
  { desc = "Previous Tab" })

vim.keymap.del("n", "<leader><tab>f")
vim.keymap.set("n", "<leader>tf", "<cmd>tabfirst<cr>",
  { desc = "First Tab" })
vim.keymap.del("n", "<leader><tab>l")
vim.keymap.set("n", "<leader>tl", "<cmd>tablast<cr>",
  { desc = "Last Tab" })
