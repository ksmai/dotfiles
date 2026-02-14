local diagnostic_config = {
	underline = true,
	update_in_insert = false,
	virtual_text = { spacing = 4, source = "if_many", prefix = "●" },
	severity_sort = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚 ",
			[vim.diagnostic.severity.WARN] = "󰀪 ",
			[vim.diagnostic.severity.INFO] = "󰋽 ",
			[vim.diagnostic.severity.HINT] = "󰌶 ",
		},
		numhl = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.HINT] = "",
			[vim.diagnostic.severity.INFO] = "",
		},
	},
}

return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "folke/neodev.nvim", opts = { experimental = { pathStrict = true } } },
			{ "Hoffs/omnisharp-extended-lsp.nvim" },
		},
		keys = {
			-- https://github.com/neovim/nvim-lspconfig#suggested-configuration
			-- Mappings.
			-- See `:help vim.diagnostic.*` for documentation on any of the below functions
			{
				"<leader>cd",
				vim.diagnostic.open_float,
				mode = "n",
				noremap = true,
				silent = true,
				desc = "Code diagnostic",
			},
			{
				"<leader>cD",
				function()
					local virtual_text = vim.diagnostic.config().virtual_text
					if virtual_text then
						vim.diagnostic.config({ virtual_text = false })
					else
						vim.diagnostic.config({
							virtual_text = diagnostic_config.virtual_text,
						})
					end
				end,
				mode = "n",
				noremap = true,
				silent = true,
				desc = "Toggle virtual text",
			},
			{
				"<leader>cq",
				vim.diagnostic.setqflist,
				mode = "n",
				noremap = true,
				silent = true,
				desc = "Code quickfix list",
			},
			{
				"[d",
				function()
					vim.diagnostic.jump({ count = -1, float = true })
				end,
				mode = "n",
				noremap = true,
				silent = true,
				desc = "Go to prev diagnostic",
			},
			{
				"]d",
				function()
					vim.diagnostic.jump({ count = 1, float = true })
				end,
				mode = "n",
				noremap = true,
				silent = true,
				desc = "Go to next diagnostic",
			},
			{
				"gd",
				function()
					if vim.bo.filetype == "cs" then
						require("omnisharp_extended").lsp_definitions()
					else
						require("fzf-lua").lsp_definitions({
							jump1 = true,
						})
					end
				end,
				mode = "n",
				noremap = true,
				silent = true,
				desc = "Go definitions",
			},
			{
				"gD",
				"<cmd>FzfLua lsp_declarations<cr>",
				mode = "n",
				noremap = true,
				silent = true,
				desc = "Go declarations",
			},
			{
				"gy",
				"<cmd>FzfLua lsp_typedefs<cr>",
				mode = "n",
				noremap = true,
				silent = true,
				desc = "Go t[y]pe definitions",
			},
			{
				"gI",
				"<cmd>FzfLua lsp_implementations<cr>",
				mode = "n",
				noremap = true,
				silent = true,
				desc = "Go implementations",
			},
			{
				"gR",
				"<cmd>FzfLua lsp_references<cr>",
				mode = "n",
				noremap = true,
				silent = true,
				desc = "Go references",
			},
			{
				"K",
				vim.lsp.buf.hover,
				mode = "n",
				noremap = true,
				silent = true,
				desc = "Hover",
			},
			{
				"<C-k>",
				vim.lsp.buf.signature_help,
				mode = "i",
				noremap = true,
				silent = true,
				desc = "Signature help",
			},
			{
				"<leader>cr",
				vim.lsp.buf.rename,
				mode = "n",
				noremap = true,
				silent = true,
				desc = "Code rename",
			},
			{
				"<leader>ca",
				"<cmd>FzfLua lsp_code_actions<cr>",
				mode = "n",
				noremap = true,
				silent = true,
				desc = "Code action",
			},
		},
		config = function()
			vim.diagnostic.config(diagnostic_config)

			vim.lsp.config("lua_ls", {
				on_init = function(client)
					if client.workspace_folders then
						local path = client.workspace_folders[1].name
						if
							path ~= vim.fn.stdpath("config")
							and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
						then
							return
						end
					end

					client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
						runtime = {
							-- Tell the language server which version of Lua you're using (most
							-- likely LuaJIT in the case of Neovim)
							version = "LuaJIT",
							-- Tell the language server how to find Lua modules same way as Neovim
							-- (see `:h lua-module-load`)
							path = {
								"lua/?.lua",
								"lua/?/init.lua",
							},
						},
						-- Make the server aware of Neovim runtime files
						workspace = {
							checkThirdParty = false,
							library = {
								vim.env.VIMRUNTIME,
								-- Depending on the usage, you might want to add additional paths
								-- here.
								-- '${3rd}/luv/library'
								-- '${3rd}/busted/library'
							},
							-- Or pull in all of 'runtimepath'.
							-- NOTE: this is a lot slower and will cause issues when working on
							-- your own configuration.
							-- See https://github.com/neovim/nvim-lspconfig/issues/3189
							-- library = {
							--   vim.api.nvim_get_runtime_file('', true),
							-- }
						},
					})
				end,
				settings = {
					Lua = {
						telemetry = { enable = false },
					},
				},
			})

			vim.lsp.config("ty", {
				settings = {
					ty = {
						experimental = {
							rename = true,
							autoImport = true,
						},
					},
				},
			})

			vim.lsp.enable({
				"jsonls",
				"yamlls",
				"html",
				"cssls",
				"lua_ls",
				"ruff",
				"ty",
				"ts_ls",
				"eslint",
				"svelte",
				"gopls",
				"qmlls",
			})
		end,
	},

	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo", "Format", "FormatDisable", "FormatEnable" },
		opts = {
			formatters = {
				ruff_fix = {
					append_args = { "--unsafe-fixes" },
				},
			},

			formatters_by_ft = {
				lua = { "stylua" },
				javascript = {
					"prettierd",
					"prettier",
					stop_after_first = true,
					lsp_format = "first",
					filter = function(client)
						return client.name == "eslint"
					end,
				},
				javascriptreact = {
					"prettierd",
					"prettier",
					stop_after_first = true,
					lsp_format = "first",
					filter = function(client)
						return client.name == "eslint"
					end,
				},
				typescript = {
					"prettierd",
					"prettier",
					stop_after_first = true,
					lsp_format = "first",
					filter = function(client)
						return client.name == "eslint"
					end,
				},
				typescriptreact = {
					"prettierd",
					"prettier",
					stop_after_first = true,
					lsp_format = "first",
					filter = function(client)
						return client.name == "eslint"
					end,
				},
				markdown = {
					"prettierd",
					"prettier",
					stop_after_first = true,
					lsp_format = "first",
					filter = function(client)
						return client.name == "eslint"
					end,
				},
				html = {
					"prettierd",
					"prettier",
					stop_after_first = true,
					lsp_format = "first",
					filter = function(client)
						return client.name == "eslint"
					end,
				},
				css = {
					"prettierd",
					"prettier",
					stop_after_first = true,
					lsp_format = "first",
					filter = function(client)
						return client.name == "eslint"
					end,
				},
				json = {
					"prettierd",
					"prettier",
					stop_after_first = true,
					lsp_format = "first",
					filter = function(client)
						return client.name == "eslint"
					end,
				},
				python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
				go = { "goimports", "gofmt" },
			},

			default_format_opts = {
				lsp_format = "fallback",
			},

			format_on_save = function(bufnr)
				-- Disable autoformat on certain filetypes
				local ignore_filetypes = {}
				if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
					return
				end
				-- Disable with a global or buffer-local variable
				if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
					return
				end
				-- Disable autoformat for files in a certain path
				local bufname = vim.api.nvim_buf_get_name(bufnr)
				if bufname:match("/node_modules/") then
					return
				end
				-- ...additional logic...
				return { timeout_ms = 500 }
			end,
		},
		config = function(_, opts)
			require("conform").setup(opts)

			vim.api.nvim_create_user_command("Format", function(args)
				local range = nil
				if args.count ~= -1 then
					local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
					range = {
						start = { args.line1, 0 },
						["end"] = { args.line2, end_line:len() },
					}
				end
				require("conform").format({ async = true, range = range })
			end, { range = true })

			vim.api.nvim_create_user_command("FormatDisable", function(args)
				if args.bang then
					-- FormatDisable! will disable formatting just for this buffer
					vim.b.disable_autoformat = true
				else
					vim.g.disable_autoformat = true
				end
			end, {
				desc = "Disable autoformat-on-save",
				bang = true,
			})

			vim.api.nvim_create_user_command("FormatEnable", function()
				vim.b.disable_autoformat = false
				vim.g.disable_autoformat = false
			end, {
				desc = "Re-enable autoformat-on-save",
			})
		end,
	},

	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("lint").linters_by_ft = {
				sh = { "shellcheck" },
			}

			vim.api.nvim_create_autocmd({ "BufWritePost" }, {
				group = vim.api.nvim_create_augroup("LintAfterWrite", { clear = true }),

				callback = function()
					require("lint").try_lint()
				end,
			})
		end,
	},

	{
		"williamboman/mason.nvim",
		cmd = { "Mason", "MasonUpdate", "MasonInstall", "MasonLog", "MasonUninstall", "MasonUninstallAll" },
		event = { "BufReadPre", "BufNewFile" },
		build = ":MasonUpdate",
		config = function()
			require("mason").setup()
		end,
	},
}
