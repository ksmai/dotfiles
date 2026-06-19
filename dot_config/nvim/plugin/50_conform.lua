local prettier = {
	"prettierd",
	"prettier",
	stop_after_first = true,
	lsp_format = "first",
	filter = function(client)
		return client.name == "eslint"
	end,
}

require("conform").setup({
	formatters = {
		ruff_fix = {
			append_args = { "--unsafe-fixes" },
		},
	},

	formatters_by_ft = {
		lua = { "stylua" },
		javascript = prettier,
		javascriptreact = prettier,
		typescript = prettier,
		typescriptreact = prettier,
		markdown = prettier,
		html = prettier,
		css = prettier,
		json = prettier,
		python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
		go = { "goimports", "gofmt" },
		http = { "kulala-fmt" },
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
	require("conform").format({ async = true, range = range })
end, { range = true })

vim.api.nvim_create_user_command("FormatDisable", function(args)
	if args.bang then
		vim.g.disable_autoformat = true
	else
		vim.b.disable_autoformat = true
	end
end, {
	desc = "Disable autoformat-on-save",
	bang = true,
})

vim.api.nvim_create_user_command("FormatEnable", function(args)
	if args.bang then
		vim.g.disable_autoformat = false
	else
		vim.b.disable_autoformat = false
	end
end, {
	desc = "Re-enable autoformat-on-save",
	bang = true,
})
