return {
    "mfussenegger/nvim-dap",
    dependencies = {

        {
            "rcarriga/nvim-dap-ui",
            keys = {
                {
                    "<leader>du",
                    function() require("dapui").toggle({ reset = true }) end,
                    desc = "Dap UI",
                },
                {
                    "<leader>de",
                    function() require("dapui").eval() end,
                    desc = "Eval",
                    mode = { "n", "v" },
                },
            },
            opts = {},
            config = function(_, opts)
                local dap = require("dap")
                local dapui = require("dapui")
                dapui.setup(opts)
                dap.listeners.after.event_initialized["dapui_config"] = function()
                    dapui.open({ reset = true })
                end
                dap.listeners.before.event_terminated["dapui_config"] = function()
                    dapui.close({})
                end
                dap.listeners.before.event_exited["dapui_config"] = function()
                    dapui.close({})
                end
            end,
        },

        {
            "theHamsta/nvim-dap-virtual-text",
            dependencies = { 'nvim-treesitter/nvim-treesitter' },
            opts = {},
        },

        {
            "jay-babu/mason-nvim-dap.nvim",
            dependencies = { "williamboman/mason.nvim" },
            cmd = { "DapInstall", "DapUninstall" },
            opts = {
                automatic_installation = false,
                handlers = {},
                ensure_installed = {
                    "chrome",
                    "codelldb",
                    "firefox",
                    "node2",
                    "python",
                },
            },
        },
    },
    keys = {
        {
            "<leader>dB",
            function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,
            desc = "Breakpoint Condition",
        },
        {
            "<leader>db",
            function() require("dap").toggle_breakpoint() end,
            desc = "Toggle Breakpoint",
        },
        {
            "<leader>dc",
            function() require("dap").continue() end,
            desc = "Continue",
        },
        {
            "<f5>",
            function() require("dap").continue() end,
            desc = "Continue",
        },
        {
            "<leader>dC",
            function() require("dap").run_to_cursor() end,
            desc = "Run to Cursor",
        },
        {
            "<leader>dg",
            function() require("dap").goto_() end,
            desc = "Go to line (no execute)",
        },
        {
            "<leader>di",
            function() require("dap").step_into() end,
            desc = "Step Into",
        },
        {
            "<f11>",
            function() require("dap").step_into() end,
            desc = "Step Into",
        },
        {
            "<leader>dj",
            function() require("dap").down() end,
            desc = "Down",
        },
        {
            "<leader>dk",
            function() require("dap").up() end,
            desc = "Up",
        },
        {
            "<leader>dl",
            function() require("dap").run_last() end,
            desc = "Run Last",
        },
        {
            "<leader>do",
            function() require("dap").step_out() end,
            desc = "Step Out",
        },
        {
            "<f12>",
            function() require("dap").step_out() end,
            desc = "Step Out",
        },
        {
            "<leader>ds",
            function() require("dap").step_over() end,
            desc = "Step Over",
        },
        {
            "<f10>",
            function() require("dap").step_over() end,
            desc = "Step Over",
        },
        {
            "<leader>dp",
            function() require("dap").pause() end,
            desc = "Pause",
        },
        {
            "<leader>dr",
            function() require("dap").repl.toggle() end,
            desc = "Toggle REPL",
        },
        {
            "<leader>dt",
            function() require("dap").terminate() end,
            desc = "Terminate",
        },
        {
            "<leader>dh",
            function() require("dap.ui.widgets").hover() end,
            desc = "Widgets",
        },
    },
    config = function()
        vim.api.nvim_set_hl(0, "DapStoppedLine", {
            default = true,
            link = "Visual",
        })
        vim.fn.sign_define("DapBreakpoint", {
            text = " ",
            texthl = "DiagnosticInfo",
            linehl = "",
            numhl = "",
        })
        vim.fn.sign_define("DapBreakpointCondition", {
            text = " ",
            texthl = "DiagnosticInfo",
            linehl = "",
            numhl = "",
        })
        vim.fn.sign_define("DapBreakpointRejected", {
            text = " ",
            texthl = "DiagnosticError",
            linehl = "",
            numhl = "",
        })
        vim.fn.sign_define("DapStopped", {
            text = "󰁕 ",
            texthl = "DiagnosticWarn",
            linehl = "DapStoppedLine",
            numhl = "DapStoppedLine",
        })
        vim.fn.sign_define("DapLogPoint", {
            text = ".>",
            texthl = "DiagnosticInfo",
            linehl = "",
            numhl = "",
        })
    end,
}