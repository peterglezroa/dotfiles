-- OPTIONS
-- colors
vim.o.termguicolors = true
-- vim.cmd.colorscheme "catppuccin"

-- tabs
vim.o.expandtab = true
vim.o.smartindent = true

vim.o.tabstop = 4
vim.o.shiftwidth = 4

-- Previous
--vim.o.tabstop = 2
--vim.o.shiftwidth = 2
--vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
--    pattern = {"*.py", "*.lua", "*.sql"},
--    callback = function()
--        vim.bo.tabstop=4
--        vim.bo.shiftwidth=4
--    end
--})

-- numbers
vim.o.number = true
vim.o.relativenumber = true
