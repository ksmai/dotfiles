return {
	"stevearc/aerial.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
		"onsails/lspkind.nvim",
		"ibhagwan/fzf-lua",
	},
	keys = {
		{
			"<leader>fs",
			"<cmd>call aerial#fzf()<cr>",
			mode = "n",
			noremap = true,
			silent = true,
			desc = "Find symbols",
		},
		{
			"<leader>fn",
			"<cmd>AerialNavOpen<cr>",
			mode = "n",
			noremap = true,
			silent = true,
			desc = "Navigate",
		},
	},
	opts = {
		highlight_on_jump = false,

		nav = {
			keymaps = {
				["q"] = "actions.close",
				["<esc>"] = "actions.close",
			},
		},
	},
}
