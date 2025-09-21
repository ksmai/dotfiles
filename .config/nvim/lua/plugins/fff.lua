return {
	"dmtrKovalenko/fff.nvim",
	lazy = false,

	build = function()
		require("fff.download").download_or_build_binary()
	end,

	keys = {
		{
			"<C-p>",
			function()
				if vim.bo.filetype == "aerial-nav" then
					local key = vim.api.nvim_replace_termcodes("<C-p>", true, false, true)
					vim.api.nvim_feedkeys(key, "n", false)
				else
					require("fff").find_files()
				end
			end,
			mode = "n",
			noremap = true,
			silent = true,
			desc = "Find files",
		},
	},

	opts = {
		prompt = "Files❯ ",
	},
}
