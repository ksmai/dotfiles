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

		vim.keymap.set("n", "gld", "<cmd>FzfLua lsp_declarations<cr>", { buf = ev.buf, desc = "LSP declarations" })

		vim.keymap.set("n", "glt", "<cmd>FzfLua lsp_typedefs<cr>", { buf = ev.buf, desc = "LSP type definitions" })

		vim.keymap.set(
			"n",
			"gli",
			"<cmd>FzfLua lsp_implementations<cr>",
			{ buf = ev.buf, desc = "LSP implementations" }
		)

		vim.keymap.set("n", "glr", "<cmd>FzfLua lsp_references<cr>", { buf = ev.buf, desc = "LSP references" })

		vim.keymap.set(
			{ "n", "x" },
			"gla",
			"<cmd>FzfLua lsp_code_actions<cr>",
			{ buf = ev.buf, desc = "LSP code action" }
		)

		vim.keymap.set("n", "gln", vim.lsp.buf.rename, { buf = ev.buf, desc = "LSP rename" })

		vim.keymap.set("n", "glx", vim.lsp.codelens.run, { buf = ev.buf, desc = "LSP codelens" })
	end,
})
