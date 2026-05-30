return {
    {
        "FabijanZulj/blame.nvim",
        lazy = false,
        config = function()
            require('blame').setup {}
        end,
        opts = {
            mappings = {
                commit_info = "i",
                stack_push = "<TAB>",
                stack_pop = "<BS>",
                show_commit = "<CR>",
                close = { "<esc>", "q" },
            }
        },
        keys = {
            { "<leader>gl", "<cmd>BlameToggle virtual<CR>", desc = "Toggle Git Blame" }
        }
    },
}
