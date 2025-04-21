return {
	"brenoprata10/nvim-highlight-colors",

	event = { "BufReadPost", "BufNewFile" },

	keys = {
		{
			"<leader>cH",
			"<cmd>HighlightColors Toggle<cr>",
			mode = "n",
			silent = true,
			noremap = true,
			desc = "Toggle highlight colors",
		},
	},

	config = function()
		require("nvim-highlight-colors").setup({
			render = "virtual",

			-- disable highlight in minified files
			exclude_buffer = function(buf)
				local line_count = vim.api.nvim_buf_line_count(buf)
				local file_size = vim.api.nvim_buf_get_offset(buf, line_count)
				return file_size / line_count > 10000
			end,
		})

		-- TODO: check integration with blink-cmp and lspkind
	end,
}
