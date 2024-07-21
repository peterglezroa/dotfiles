-- OPTIONS
-- colors
vim.o.termguicolors = true
-- vim.cmd.colorscheme "catppuccin"

-- tabs
vim.o.expandtab = true
vim.o.smartindent = true

vim.o.tabstop = 2
vim.o.shiftwidth = 2

vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
    pattern = {"*.py", "*.lua"},
    callback = function()
        vim.bo.tabstop=4
        vim.bo.shiftwidth=4
    end
})

-- numbers
vim.o.number = true
vim.o.relativenumber = true
