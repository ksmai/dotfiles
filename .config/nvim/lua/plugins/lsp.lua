return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "folke/neodev.nvim", opts = { experimental = { pathStrict = true } } },
			"williamboman/mason.nvim",
			{ "williamboman/mason-lspconfig.nvim" },
			"SmiteshP/nvim-navic",
			"hrsh7th/nvim-cmp",
			"ibhagwan/fzf-lua",
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
							virtual_text = {
								spacing = 4,
								source = "if_many",
								prefix = "●",
							},
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
				"<leader>cl",
				vim.diagnostic.setloclist,
				mode = "n",
				noremap = true,
				silent = true,
				desc = "Code location list",
			},
			{
				"[d",
				vim.diagnostic.goto_prev,
				mode = "n",
				noremap = true,
				silent = true,
				desc = "Go to prev diagnostic",
			},
			{
				"]d",
				vim.diagnostic.goto_next,
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
							jump_to_single_result = true,
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
				"gr",
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
				mode = { "n", "i" },
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
			{
				"<leader>cf",
				function()
					vim.cmd("Format")
				end,
				mode = "n",
				noremap = true,
				silent = true,
				desc = "Code format",
			},
			{
				"<leader>cf",
				function()
					vim.cmd("Format")
				end,
				mode = "v",
				noremap = true,
				silent = true,
				desc = "Code format in range",
			},
		},
		opts = {
			diagnostics = {
				underline = true,
				update_in_insert = false,
				virtual_text = { spacing = 4, source = "if_many", prefix = "●" },
				severity_sort = true,
			},
			capabilities = {},
			autoformat = true,
			servers = {
				jsonls = {},
				lua_ls = {
					settings = {
						Lua = {
							telemetry = { enable = false },
							runtime = { version = "LuaJIT" },
							workspace = { checkThirdParty = false },
						},
					},
				},
				pylsp = {},
				ts_ls = {},
				eslint = {
					on_attach = function(_, bufnr)
						vim.api.nvim_create_autocmd("BufWritePre", {
							buffer = bufnr,
							command = "EslintFixAll",
						})
					end,
				},
				svelte = {},
				omnisharp = {
					cmd = { "/home/ksmai/.local/share/nvim/mason/bin/omnisharp" },
				},
				tailwindcss = {},
			},
			setup = {
				-- example to setup with typescript.nvim
				-- ts_ls = function(_, opts)
				--   require("typescript").setup({ server = opts })
				--   return true
				-- end,
				-- Specify * to use this function as a fallback for any server
				-- ["*"] = function(server, opts) end,
			},
		},
		config = function(_, opts)
			vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

			local servers = opts.servers
			local capabilities = vim.tbl_deep_extend(
				"force",
				{},
				vim.lsp.protocol.make_client_capabilities(),
				require("cmp_nvim_lsp").default_capabilities(),
				opts.capabilities or {}
			)

			local function on_attach_fmt(client, bufnr)
				if not opts.autoformat then
					return
				end

				if
					client.config
					and client.config.capabilities
					and client.config.capabilities.documentFormattingProvider == false
				then
					return
				end

				if not client.supports_method("textDocument/formatting") then
					return
				end
			end

			local function setup(server)
				local server_config = servers[server] or {}
				local server_opts = vim.tbl_deep_extend("force", {
					capabilities = vim.deepcopy(capabilities),
				}, server_config)

				local function on_attach(client, bufnr)
					if server_config.on_attach ~= nil then
						server_config.on_attach(client, bufnr)
					end
					on_attach_fmt(client, bufnr)
					if client.server_capabilities.documentSymbolProvider then
						require("nvim-navic").attach(client, bufnr)
					end
				end

				server_opts.on_attach = on_attach

				if opts.setup[server] then
					if opts.setup[server](server, server_opts) then
						return
					end
				elseif opts.setup["*"] then
					if opts.setup["*"](server, server_opts) then
						return
					end
				end
				require("lspconfig")[server].setup(server_opts)
			end

			local mlsp = require("mason-lspconfig")
			local all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
			local ensure_installed = {}

			for server, server_opts in pairs(servers) do
				if server_opts then
					server_opts = server_opts == true and {} or server_opts
					-- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
					if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
						setup(server)
					else
						ensure_installed[#ensure_installed + 1] = server
					end
				end
			end

			mlsp.setup({ ensure_installed = ensure_installed })
			mlsp.setup_handlers({ setup })

			local icons = {
				Error = "󰅚 ", -- x000f015a
				Warn = "󰀪 ", -- x000f002a
				Info = "󰋽 ", -- x000f02fd
				Hint = "󰌶 ", -- x000f0336
			}
			for name, icon in pairs(icons) do
				name = "DiagnosticSign" .. name
				vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
			end
		end,
	},
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					javascript = { { "prettierd", "prettier" } },
					typescript = { { "prettierd", "prettier" } },
					html = { { "prettierd", "prettier" } },
					htmldjango = { { "prettierd", "prettier" } },
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
					return { timeout_ms = 500, lsp_fallback = true }
				end,
			})

			vim.api.nvim_create_user_command("Format", function(args)
				local range = nil
				if args.count ~= -1 then
					local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
					range = {
						start = { args.line1, 0 },
						["end"] = { args.line2, end_line:len() },
					}
				end
				require("conform").format({ async = true, lsp_fallback = true, range = range })
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
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		config = function()
			require("mason").setup()
		end,
	},
}
