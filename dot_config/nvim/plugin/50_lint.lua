require("lint").linters_by_ft = {
	sh = { "shellcheck" },
}

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	group = vim.api.nvim_create_augroup("LintAfterWrite", { clear = true }),

	callback = function()
		require("lint").try_lint()
	end,
})
