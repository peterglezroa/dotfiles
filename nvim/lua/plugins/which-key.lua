return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        spec = {
            {"<leader>g", group = "git" },
            {"<leader>f", group = "file/find" },
        }
    }
}
