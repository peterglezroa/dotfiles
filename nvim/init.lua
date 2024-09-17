require("config.lazy")
require("config.keymaps")
require("config.options")

--vim.cmd [[colorscheme lushwal]]

require("lualine").setup()
require("pywal").setup()

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
