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

-- https://github.com/neovim/nvim-lspconfig#suggested-configuration
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "LSP Code diagnostic" })

vim.keymap.set("n", "<leader>cD", function()
	local virtual_text = vim.diagnostic.config().virtual_text
	if virtual_text then
		vim.diagnostic.config({ virtual_text = false })
	else
		vim.diagnostic.config({
			virtual_text = diagnostic_config.virtual_text,
		})
	end
end, { desc = "LSP Toggle virtual text" })

vim.keymap.set("n", "<leader>cq", vim.diagnostic.setqflist, { desc = "LSP Code quickfix list" })

vim.keymap.set("n", "[d", function()
	vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "LSP Go to prev diagnostic" })

vim.keymap.set("n", "]d", function()
	vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "LSP Go to next diagnostic" })

vim.keymap.set("n", "gd", function()
	if vim.bo.filetype == "cs" then
		require("omnisharp_extended").lsp_definitions()
	else
		require("fzf-lua").lsp_definitions({
			jump1 = true,
		})
	end
end, { desc = "LSP Go definitions" })

vim.keymap.set("n", "gD", "<cmd>FzfLua lsp_declarations<cr>", { desc = "LSP Go declarations" })

vim.keymap.set("n", "gy", "<cmd>FzfLua lsp_typedefs<cr>", { desc = "LSP Go t[y]pe definitions" })

vim.keymap.set("n", "gI", "<cmd>FzfLua lsp_implementations<cr>", { desc = "LSP Go implementations" })

vim.keymap.set("n", "gR", "<cmd>FzfLua lsp_references<cr>", { desc = "LSP Go references" })

vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "LSP Hover" })

vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, { desc = "LSP Signature help" })

vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "LSP Code rename" })

vim.keymap.set("n", "<leader>ca", "<cmd>FzfLua lsp_code_actions<cr>", { desc = "LSP Code action" })
