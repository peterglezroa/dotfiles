-- Windows
vim.keymap.set("n", "<leader>l", ":Lazy<CR>",
{ silent = true, desc="Open the Lazy Window" })
vim.keymap.set("n", "<leader>m", ":Mason<CR>",
{ silent = true, desc="Open the Mason Window" })

-- Health
vim.keymap.set("n", "<leader>H", ":checkhealth<CR>",
{ silent = true, desc="Check Vim's health" })

-- Reload vim
vim.keymap.set("n", "<leader>r", ":so $MYVIMRC<CR>",
{ silent = true, desc="Reload Vim" })

-- Clear search
vim.keymap.set("n", "<leader><leader>", ":nohl<CR>",
{ silent = true, desc="Clear search" })
