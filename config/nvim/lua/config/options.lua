-- OPTIONS
-- colors
vim.o.termguicolors = true
-- vim.cmd.colorscheme "catppuccin"

-- tabs
vim.o.expandtab = true
vim.o.smartindent = true

vim.o.tabstop = 4
vim.o.shiftwidth = 4

vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
    pattern = {"*.c", "*.cpp", "*.h", "*.js", "*.ts", "*.html"},
    callback = function()
        vim.bo.tabstop=2
        vim.bo.shiftwidth=2
    end
})

-- numbers
vim.o.number = true
vim.o.relativenumber = true
