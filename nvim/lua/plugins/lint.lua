return {
    "mfussenegger/nvim-lint",
    config = function()
        local lint = require("lint")
        lint.linters_by_ft = {
            -- c/cpp
            cpp = {
                "cpplint"
            },
            c = {
                "cpplint"
            },

            -- rust

            -- javascript
            javascript = {
                "eslint_d"
            },
            typescript = {
                "eslint_d"
            },
            javascriptreact = {
                "eslint_d"
            },
            typescriptreact = {
                "eslint_d"
            }
        }
    end
}
