return {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = function()
        local telescope = require("telescope.builtin")
        local utils = require("telescope.utils")
        local ext = require("telescope").extensions

        return {
            -- File tree
            {"<leader>e",
                function()
                    ext.file_browser.file_browser({
                        initial_mode="normal",
                        cwd=utils.buffer_dir()
                    })
                end,
                desc = "File browser"},
            {"<leader>E",
                function()
                    ext.file_browser.file_browser({initial_mode="normal"})
                end,
                desc = "File browser from root"},

            -- Search file
            { "<leader>ff",
                function() telescope.find_files({ hidden=true }) end,
                desc = "Find files" },

            -- Search file from home
            { "<leader>fF",
                function()
                    telescope.find_files({cwd=os.getenv("HOME"), hidden=true})
                end,
                desc = "Find files starting the search from home" },

            -- Search with grep
            { "<leader>fg", telescope.live_grep,
                desc = "Search files contents with grep" },

            -- Search in buffers
            { "<leader>fb", telescope.buffers,
                desc = "Search on buffers" },

            -- Search treesitter file
            { "<leader>f/", telescope.treesitter,
                desc = "Search treesitter on file" },

            -- Search in help
            { "<leader>fh", telescope.help_tags,
                desc = "Search help" },

            -- Search in help
            { "<leader>fm", telescope.man_pages,
                desc = "Search in manuals" },

            -- GIT
            -- Search in git commits
            { "<leader>gc", telescope.git_commits,
                desc = "Display git commits" },

            -- Git branches
            { "<leader>gb", telescope.git_branches,
                desc = "Display git branches" },

            -- Git status
            { "<leader>gs", telescope.git_status,
                desc = "Display git status" },

            -- Diagnostics
            { "<leader>fd", telescope.diagnostics,
                desc = "Display code diagnostics" },
        }
    end, 
    opts = {
        defaults = {
--            initial_mode = "normal",
            sorting_strategy = "ascending",
            layout_strategy = "flex",
            layout_config = {
                prompt_position = "top",
                flex = {
                    flip_columns = 160 -- Two 80 col windows at least
                },
                vertical = {
                    mirror = true
                }
            },
            preview_cutoff = 160,
            mappings = {
                n = {
                    ["<leader>h"] = "select_horizontal",
                    ["<leader>v"] = "select_vertical",
                    ["<leader>t"] = "select_tab",
                    ["l"] = "preview_scrolling_up",
                    [";"] = "preview_scrolling_down",

                    ["<C-T>"] = false,
                    ["<C-V>"] = false,
                    ["<C-X>"] = false
                }
            }
        },
    },
    config = function(PluginSpec, opts)
        require("telescope").load_extension "file_browser"
        require("telescope").setup(opts)
    end
}
