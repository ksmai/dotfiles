local diagnostic_config = {
	jump = {
		on_jump = function(diagnostic, bufnr)
			if not diagnostic then
				return
			end

			vim.diagnostic.open_float({
				bufnr = bufnr,
				scope = "cursor",
				focus = false,
			})
		end,
	},
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

vim.diagnostic.config(diagnostic_config)

vim.keymap.set("n", "<leader>cD", function()
	local virtual_text = vim.diagnostic.config().virtual_text
	if virtual_text then
		vim.diagnostic.config({ virtual_text = false })
	else
		vim.diagnostic.config({
			virtual_text = diagnostic_config.virtual_text,
		})
	end
end, { desc = "Toggle diagnostic virtual text" })

vim.keymap.set("n", "<leader>cq", vim.diagnostic.setqflist, { desc = "Set diagnostic quickfix list" })

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

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("LspKeymaps", { clear = true }),

	callback = function(ev)
		vim.keymap.set(
			"n",
			"gd",
			"<cmd>FzfLua lsp_definitions jump1=true<cr>",
			{ buf = ev.buf, desc = "LSP definitions" }
		)

		vim.keymap.set("n", "grd", "<cmd>FzfLua lsp_declarations<cr>", { buf = ev.buf, desc = "LSP declarations" })

		vim.keymap.set("n", "grt", "<cmd>FzfLua lsp_typedefs<cr>", { buf = ev.buf, desc = "LSP type definitions" })

		vim.keymap.set(
			"n",
			"gri",
			"<cmd>FzfLua lsp_implementations<cr>",
			{ buf = ev.buf, desc = "LSP implementations" }
		)

		vim.keymap.set("n", "grr", "<cmd>FzfLua lsp_references<cr>", { buf = ev.buf, desc = "LSP references" })

		vim.keymap.set(
			{ "n", "x" },
			"gra",
			"<cmd>FzfLua lsp_code_actions<cr>",
			{ buf = ev.buf, desc = "LSP Code action" }
		)
	end,
})
