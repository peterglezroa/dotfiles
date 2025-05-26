return {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = true,
    opts = {
        colorscheme = "gruvbox",
    },
    config = function()
        require("gruvbox").setup({
            transparent_mode = true
        })
    end
}
