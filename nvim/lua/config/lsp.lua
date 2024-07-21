local lspconfig = require("lspconfig")

-- Check C
lspconfig.clangd.setup({
})

-- Check C++

-- Check Rust
lspconfig.rust_analyzer.setup({
    on_attach = function(_, bufnr)
	vim.lsp.inlay_hint.enable(true, { bufnr = bufnr} )
    end
    settings = {
        ["rust-analyzer"] = {
            imports = {
                granularity = {
                    group = "module",
                },
                prefix = "self",
            },
            cargo = {
                buildScripts = {
                    enable = true,
                },
            },
            procMacro = {
                enable = true
            },
        }
    }
})

-- Check Python
lspconfig.pyright.setup{}

-- Check Javascript

-- Check Lua
lspconfig.lua_ls.setup({
    settings = {
        Lua = {
            diagnostics = {
                globals = {
                    'vim'
                }
            }
        }
    }
})
