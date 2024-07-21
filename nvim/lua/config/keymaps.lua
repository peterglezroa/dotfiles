-- Custom

-- Lazy window
vim.keymap.set("n", "<leader>l", ":Lazy<CR>", { silent = true })

-- Reload vim
vim.keymap.set("n", "<leader>r", ":so $MYVIMRC<CR>", { silent = true })

-- Clear search
vim.keymap.set("n", "<leader><leader>", ":nohl<CR>", { silent = true })

-- LSP
--vim.keymap.set("n",  "<leader>k", function() vim.diagnostic.open_float({ scope = "line" }) end, { silent = true })
