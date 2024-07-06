return {
	"folke/todo-comments.nvim",
	event = { "BufReadPost", "BufNewFile" },
	keys = {
		{
			"<leader>ft",
			"<cmd>TodoQuickFix<cr>",
			mode = "n",
			noremap = true,
			silent = true,
			desc = "Find TODOs",
		},
	},
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
	},
}
