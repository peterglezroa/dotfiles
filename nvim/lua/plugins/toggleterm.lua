return {
    'akinsho/toggleterm.nvim', version = "*",
    opts = {
        direction = "float",
        float_opts = {
            border = "curved",
        },
    },
    keys = function()
        toggleterm = require("toggleterm")
        return {
            -- Toggle terminal
            {"<leader>t", ":ToggleTerm<cr>", desc="Toogle terminal"},
            -- Hide the terminal during normal mode
            {"<C-H>", [[<Cmd>wincmd h<cr>]],
                desc="Hide the terminal during normal mode"},

            -- Hide the terminal during terminal mode
            {"<C-H>", [[<Cmd>wincmd h<cr>]], mode="t",
                desc="Hide the terminal during terminal mode"},

            -- Stop terminal mode while on terminal
            {"<esc>", [[<C-\><C-n>]], mode="t",
                desc="Stop terminal mode to enter normal mode"},

            -- Transfer lines to terminal on view mode
            {"<leader>t", function()
                toggleterm.send_lines_to_terminal("single_line",
                    trim_spaces, { args = vim.v.count }
                )
            end, mode="v", desc = "Send lines to terminal"}
        }
    end,
}
