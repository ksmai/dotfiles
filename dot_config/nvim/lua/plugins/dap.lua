return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			{
				"rcarriga/nvim-dap-ui",
				dependencies = { "nvim-neotest/nvim-nio" },
				keys = {
					{
						"<leader>du",
						function()
							require("dapui").toggle({ reset = true })
						end,
						desc = "Dap UI",
					},
					{
						"<C-\\>",
						function()
							require("dapui").eval()
						end,
						desc = "Eval",
						mode = { "n", "v" },
					},
					{
						"<leader>fd",
						"<cmd>FzfLua dap_commands<cr>",
						mode = "n",
						noremap = true,
						silent = true,
						desc = "Find DAP commands",
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
				dependencies = { "nvim-treesitter/nvim-treesitter" },
				opts = {
					display_callback = function(variable)
						local limit = 25
						if #variable.value > limit then
							return " " .. variable.value:sub(1, limit) .. "..."
						end
						return " " .. variable.value
					end,
				},
			},
			{
				"jay-babu/mason-nvim-dap.nvim",
				dependencies = { "williamboman/mason.nvim" },
				cmd = { "DapInstall", "DapUninstall" },
				opts = {
					automatic_installation = false,
					handlers = {},
					ensure_installed = { "codelldb", "python", "coreclr" },
				},
			},
		},
		keys = {
			{
				"<C-CR>",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Toggle Breakpoint",
			},
			{
				"<C-.>",
				function()
					require("dap").down()
				end,
				desc = "Down",
			},
			{
				"<C-,>",
				function()
					require("dap").up()
				end,
				desc = "Up",
			},
			{
				"<C-;>",
				function()
					require("dap").step_into()
				end,
				desc = "Step Into",
			},
			{
				"<C-S-;>",
				function()
					require("dap").step_out()
				end,
				desc = "Step Out",
			},
			{
				"<C-'>",
				function()
					require("dap").step_over()
				end,
				desc = "Step Over",
			},
			{
				"<C-S-'>",
				function()
					require("dap").run_to_cursor()
				end,
				desc = "Run to Cursor",
			},
			{
				"<C-/>",
				function()
					require("dap").continue()
				end,
				desc = "Continue",
			},
			{
				"<C-S-/>",
				function()
					require("dap").terminate()
				end,
				desc = "Terminate",
			},
		},
		config = function()
			vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
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
	},
	{
		"mxsdev/nvim-dap-vscode-js",
		ft = {
			"typescript",
			"javascript",
			"typescriptreact",
			"javascriptreact",
		},
		dependencies = { "mfussenegger/nvim-dap", "microsoft/vscode-js-debug" },
		config = function()
			require("dap-vscode-js").setup({
				debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
				adapters = {
					"pwa-node",
					"pwa-chrome",
					"pwa-msedge",
					"node-terminal",
					"pwa-extensionHost",
				},
			})

			local languages = {
				"typescript",
				"javascript",
				"typescriptreact",
				"javascriptreact",
			}

			local configurations = {
				{
					type = "pwa-node",
					request = "launch",
					name = "Node: Launch file",
					program = "${file}",
					cwd = "${workspaceFolder}",
				},
				{
					type = "pwa-node",
					request = "attach",
					name = "Node: Attach",
					processId = require("dap.utils").pick_process,
					cwd = "${workspaceFolder}",
				},
				{
					type = "pwa-node",
					request = "launch",
					name = "Debug Jest Tests",
					runtimeExecutable = "node",
					runtimeArgs = {
						"./node_modules/jest/bin/jest.js",
						"--runInBand",
					},
					rootPath = "${workspaceFolder}",
					cwd = "${workspaceFolder}",
					console = "integratedTerminal",
					internalConsoleOptions = "neverOpen",
				},
			}

			for _, language in ipairs(languages) do
				require("dap").configurations[language] = configurations
			end
		end,
	},
	{
		"microsoft/vscode-js-debug",
		ft = {
			"typescript",
			"javascript",
			"typescriptreact",
			"javascriptreact",
		},
		build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
	},
}
