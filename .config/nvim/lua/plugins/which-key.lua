return {
    "folke/which-key.nvim",
    config = function(_, opts)
        vim.opt.timeout = true
        vim.opt.timeoutlen = 500
        local wk = require("which-key")
        wk.setup(opts)
        wk.register({
            ["<leader>c"] = { name = "+code" },
            ["<leader>d"] = { name = "+diff" },
            ["<leader>f"] = { name = "+find" },
            ["<leader>g"] = { name = "+git" },
            ["<leader>s"] = { name = "+treesj" },
        })
    end,
}