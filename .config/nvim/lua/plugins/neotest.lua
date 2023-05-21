return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter",
        {"antoinemadec/FixCursorHold.nvim"}, "mfussenegger/nvim-dap",
        "nvim-neotest/neotest-python", "rouge8/neotest-rust",
        "nvim-neotest/neotest-jest"
    },
    keys = {
        {
            "<leader>rt",
            function() require("neotest").run.run() end,
            mode = "n",
            noremap = true,
            silent = true,
            desc = "Run nearest test"
        }, {
            "<leader>rd",
            function() require("neotest").run.run({strategy = "dap"}) end,
            mode = "n",
            noremap = true,
            silent = true,
            desc = "Debug nearest test"
        }, {
            "<leader>rT",
            function() require("neotest").run.stop() end,
            mode = "n",
            noremap = true,
            silent = true,
            desc = "Terminate"
        }, {
            "<leader>rf",
            function() require("neotest").run.run(vim.fn.expand("%")) end,
            mode = "n",
            noremap = true,
            silent = true,
            desc = "Run current file"
        }, {
            "<leader>ro",
            function() require("neotest").output_panel.toggle() end,
            mode = "n",
            noremap = true,
            silent = true,
            desc = "Toggle output panel"
        }, {
            "<leader>rs",
            function() require("neotest").summary.toggle() end,
            mode = "n",
            noremap = true,
            silent = true,
            desc = "Toggle summary window"
        }
    },
    opts = function()
        return {
            adapters = {
                require("neotest-python"), require("neotest-rust"),
                require('neotest-jest')({})
            }
        }
    end
}
