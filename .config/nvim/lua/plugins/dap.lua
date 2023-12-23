return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {

            {
                "rcarriga/nvim-dap-ui",
                keys = {
                    {
                        "<leader>du",
                        function()
                            require("dapui").toggle({reset = true})
                        end,
                        desc = "Dap UI"
                    }, {
                        "<leader>de",
                        function()
                            require("dapui").eval()
                        end,
                        desc = "Eval",
                        mode = {"n", "v"}
                    }, {
                        "<leader>fb",
                        "<cmd>FzfLua dap_breakpoints<cr>",
                        mode = "n",
                        noremap = true,
                        silent = true,
                        desc = "Find breakpoints"
                    }, {
                        "<leader>fd",
                        "<cmd>FzfLua dap_commands<cr>",
                        mode = "n",
                        noremap = true,
                        silent = true,
                        desc = "Find DAP commands"
                    }
                },
                opts = {},
                config = function(_, opts)
                    local dap = require("dap")
                    local dapui = require("dapui")
                    dapui.setup(opts)
                    dap.listeners.after.event_initialized["dapui_config"] =
                        function()
                            dapui.open({reset = true})
                        end
                    dap.listeners.before.event_terminated["dapui_config"] =
                        function() dapui.close({}) end
                    dap.listeners.before.event_exited["dapui_config"] =
                        function() dapui.close({}) end
                end
            }, {
                "theHamsta/nvim-dap-virtual-text",
                dependencies = {'nvim-treesitter/nvim-treesitter'},
                opts = {}
            }, {
                "jay-babu/mason-nvim-dap.nvim",
                dependencies = {"williamboman/mason.nvim"},
                cmd = {"DapInstall", "DapUninstall"},
                opts = {
                    automatic_installation = false,
                    handlers = {},
                    ensure_installed = {"codelldb", "python", "coreclr"}
                }
            }, "ibhagwan/fzf-lua"
        },
        keys = {
            {
                -- same as <c-f4> in kitty
                "<f28>",
                function()
                    require("dap").set_breakpoint(vim.fn.input(
                                                      'Breakpoint condition: '))
                end,
                desc = "Breakpoint Condition"
            }, {
                "<f4>",
                function() require("dap").toggle_breakpoint() end,
                desc = "Toggle Breakpoint"
            },
            {
                "<f5>",
                function() require("dap").continue() end,
                desc = "Continue"
            }, {
                -- same as <c-f10> in kitty
                "<f34>",
                function() require("dap").run_to_cursor() end,
                desc = "Run to Cursor"
            },
            {
                "<f11>",
                function() require("dap").step_into() end,
                desc = "Step Into"
            },
            {"<leader>dj", function() require("dap").down() end, desc = "Down"},
            {"<leader>dk", function() require("dap").up() end, desc = "Up"},
            {
                "<leader>dl",
                function() require("dap").run_last() end,
                desc = "Run Last"
            },
            {
                "<f12>",
                function() require("dap").step_out() end,
                desc = "Step Out"
            },
            {
                "<f10>",
                function() require("dap").step_over() end,
                desc = "Step Over"
            },
            {
                "<leader>dp",
                function() require("dap").pause() end,
                desc = "Pause"
            }, {
                "<leader>dr",
                function() require("dap").repl.toggle() end,
                desc = "Toggle REPL"
            }, {
                -- same as <c-f5> in kitty
                "<f29>",
                function() require("dap").terminate() end,
                desc = "Terminate"
            }
        },
        config = function()
            vim.api.nvim_set_hl(0, "DapStoppedLine",
                                {default = true, link = "Visual"})
            vim.fn.sign_define("DapBreakpoint", {
                text = " ",
                texthl = "DiagnosticInfo",
                linehl = "",
                numhl = ""
            })
            vim.fn.sign_define("DapBreakpointCondition", {
                text = " ",
                texthl = "DiagnosticInfo",
                linehl = "",
                numhl = ""
            })
            vim.fn.sign_define("DapBreakpointRejected", {
                text = " ",
                texthl = "DiagnosticError",
                linehl = "",
                numhl = ""
            })
            vim.fn.sign_define("DapStopped", {
                text = "󰁕 ",
                texthl = "DiagnosticWarn",
                linehl = "DapStoppedLine",
                numhl = "DapStoppedLine"
            })
            vim.fn.sign_define("DapLogPoint", {
                text = ".>",
                texthl = "DiagnosticInfo",
                linehl = "",
                numhl = ""
            })
        end
    }, {
        "mxsdev/nvim-dap-vscode-js",
        dependencies = {"mfussenegger/nvim-dap", "microsoft/vscode-js-debug"},
        config = function()
            require("dap-vscode-js").setup({
                debugger_path = vim.fn.stdpath("data") ..
                    "/lazy/vscode-js-debug",
                adapters = {
                    'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal',
                    'pwa-extensionHost'
                }
            })

            local languages = {
                "typescript", "javascript", "typescriptreact", "javascriptreact"
            }

            local configurations = {
                {
                    type = "pwa-node",
                    request = "launch",
                    name = "Node: Launch file",
                    program = "${file}",
                    cwd = "${workspaceFolder}"
                }, {
                    type = "pwa-node",
                    request = "attach",
                    name = "Node: Attach",
                    processId = require('dap.utils').pick_process,
                    cwd = "${workspaceFolder}"
                }, {
                    type = "pwa-node",
                    request = "launch",
                    name = "Debug Jest Tests",
                    runtimeExecutable = "node",
                    runtimeArgs = {
                        "./node_modules/jest/bin/jest.js", "--runInBand"
                    },
                    rootPath = "${workspaceFolder}",
                    cwd = "${workspaceFolder}",
                    console = "integratedTerminal",
                    internalConsoleOptions = "neverOpen"
                }
            }

            for _, language in ipairs(languages) do
                require("dap").configurations[language] = configurations
            end
        end
    }, {
        "microsoft/vscode-js-debug",
        build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out"
    }
}
