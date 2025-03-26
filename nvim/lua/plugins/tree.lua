-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1


return {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
        "nvim-tree/nvim-web-devicons"
    },
    opts = {
        filters = {
            dotfiles = true
        },
        on_attach = function (bufnr)
            local api = require "nvim-tree.api"
            local function opts(desc)
                return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
            end

            -- Default mappings
            api.config.mappings.default_on_attach(bufnr)

            -- Custom mappings
            vim.keymap.set("n", "C", api.tree.change_root_to_node, opts("CD"))
            vim.keymap.set("n", "s", api.node.open.vertical, opts("Open: Vertical Split"))
            vim.keymap.set("n", "i", api.node.open.horizontal, opts("Open: Horizontal Split"))
            vim.keymap.set("n", "x", api.node.open.edit, opts("Open"))

        end
    },
    keys = {
        {"<C-n>", ":NvimTreeToggle<CR>", { silent = true }}
    }
}
