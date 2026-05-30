-- OPTIONS
-- colors
vim.o.termguicolors = true
-- vim.cmd.colorscheme "catppuccin"

-- tabs
vim.o.expandtab = true
vim.o.smartindent = true

vim.o.tabstop = 4
vim.o.shiftwidth = 4

-- 2 tab according to standards
vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
    pattern = {"*.js", "*.html", "*.css", "*.scss", "*.sass"},
    callback = function()
        vim.bo.tabstop=2
        vim.bo.shiftwidth=2
    end
})

-- numbers
vim.o.number = true
vim.o.relativenumber = true

-- nvim lint
vim.api.nvim_create_autocmd({"BufWritePost", "InsertLeave"}, {
    callback = function()
        local lint_status, lint = pcall(require, "lint")
        if lint_status then
            lint.try_lint()
        end
    end,
})
