return {
    "neovim/nvim-lspconfig",
    lazy = false,
    keys = {
        {"<leader>k", function() vim.diagnostic.open_float({ scope = "line" }) end }
    }
}
