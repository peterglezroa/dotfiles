return {
    "nvim-telescope/telescope.nvim",
    keys = function()
        local telescope = require("telescope.builtin")
        return {
            -- Search file
            { "<leader>ff", telescope.find_files, desc = "Find Files" },

            -- Search with grep
            { "<leader>fg", telescope.live_grep, desc = "Search files contents with grep" },

            -- Search in buffers
            { "<leader>fb", telescope.buffers, desc = "Search on buffers" },

            -- Search treesitter file
            { "<leader>f/", telescope.treesitter, desc = "Search treesitter on file" },

            -- Search in help
            { "<leader>fh", telescope.help_tags, desc = "Search help" },

            -- Search in help
            { "<leader>fm", telescope.man_pages, desc = "Search in manuals" },


            -- Scroll preview (in normal mode after one esc)
            -- u up
            -- i down

            -- GIT
            -- Search in git commits
            { "<leader>gc", telescope.git_commits, desc = "Display git commits" },

            -- Git branches
            { "<leader>gb", telescope.git_branches, desc = "Display git branches" },

            -- Git status
            { "<leader>gs", telescope.git_status, desc = "Display git status" },
        }
    end, 
    opts = {
        defaults = {
            layout_strategy = "flex",
            layout_config = {
                flex = {
                    flip_columns = 160 -- Two 80 col windows at least
                }
            },
            preview_cutoff = 160,
        }
    }
}
