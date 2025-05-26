require("config.lazy")
require("config.keymaps")
require("config.options")

require("lualine").setup()

-- colorschemes

-- Pywal?
-- Option 1
-- vim.cmd [[colorscheme lushwal]]
-- Option 2
-- require("pywal").setup()

-- Grubox
vim.o.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme gruvbox]])

-- PLUGIN EXAMPLE
-- return {
    -- plugin string repo,
    -- [opt] version = "*" <- latest version
    -- lazy = false <- always available (false) vs load when needed (default: true)
    -- dependencies = {} <- lol
    -- opts = {
        -- on_attach = function () <- like a prescript
            -- too complicated >.<
        -- end
    -- } <- puglins options
    -- config = function() <- function that is executed after the plugin loads
        -- bla bla
    -- end
