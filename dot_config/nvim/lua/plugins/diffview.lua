return {
	"sindrets/diffview.nvim",

	cmd = {
		"DiffviewFileHistory",
		"DiffviewOpen",
	},

	keys = {
		{
			"<leader>db",
			"<cmd>DiffviewFileHistory %<cr>",
			mode = "n",
			silent = true,
			noremap = true,
			desc = "View file history for current buffer",
		},
		{
			"<leader>db",
			"<esc><cmd>'<,'>DiffviewFileHistory<cr>",
			mode = "v",
			silent = true,
			noremap = true,
			desc = "View file history for selected range",
		},
		{
			"<leader>dc",
			"<cmd>DiffviewClose<cr>",
			mode = "n",
			silent = true,
			noremap = true,
			desc = "Close Diffview",
		},
	},

	opts = {
		enhanced_diff_hl = true,

		view = {
			default = {
				disable_diagnostics = true,
			},
		},
	},

	init = function()
		vim.opt.fillchars:append("diff:╱")
	end,
}
