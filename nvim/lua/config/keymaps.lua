-- Windows
vim.keymap.set("n", "<leader>L", ":Lazy<CR>",
{ silent = true, desc="Open the Lazy Window" })
vim.keymap.set("n", "<leader>M", ":Mason<CR>",
{ silent = true, desc="Open the Mason Window" })
vim.keymap.del("n", "<leader>m")

-- Health
vim.keymap.set("n", "<leader>H", ":checkhealth<CR>",
{ silent = true, desc="Check Vim's health" })

-- Reload vim
vim.keymap.set("n", "<leader>R", ":so $MYVIMRC<CR>",
{ silent = true, desc="Reload Vim" })

-- Clear search
vim.keymap.set("n", "<leader><leader>", ":nohl<CR>",
{ silent = true, desc="Clear search" })

-- Toggle 80 column
vim.keymap.set("n", "<leader>l",
    function()
        if vim.opt.colorcolumn._value=="80" then
            vim.opt.colorcolumn = ""
        else
            vim.opt.colorcolumn = "80"
        end
    end,
{ silent = true, desc="Highlight 80th column"});
