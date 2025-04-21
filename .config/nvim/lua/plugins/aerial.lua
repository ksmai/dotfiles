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

			-- kitty relies on the space following a double-width icon to
			-- properly render it, but if the window is not opaque, sometimes
			-- another character from behind might take up the space, causing
			-- the icon to be randomly smaller or truncated. See:
			-- https://github.com/kovidgoyal/kitty/issues/6210
			win_opts = {
				winblend = 0,
			},
		},
	},
}
