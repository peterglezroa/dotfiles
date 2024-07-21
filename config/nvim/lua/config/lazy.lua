local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.localmapleader = "\\"

-- setup lazy.nvim
require("lazy").setup({
    spec = {
        -- automatically import plugins
        { import = "plugins" },
    },

    install = {
        colorscheme = { "catppuccin" }
    },

    -- auto-check plugins updates
    checker = { enable = true }
})
