return {
	"stevearc/aerial.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
		"onsails/lspkind.nvim",
		"ibhagwan/fzf-lua",
		"ellisonleao/gruvbox.nvim",
	},
	keys = {
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

			-- fix the width and height so that the window does not jump around
			-- during navigation
			height = 0.9,
			max_height = 0.9,
			min_height = 0.9,

			-- some texts might get cut off if width * 3 is close to 1.0. This
			-- might be because the plugin accounts for the border width
			-- wrongly. There are 4 borders in total to separate the 3 windows,
			-- but the plugin only subtracts border_width * 2 from the total
			-- width.
			width = 0.32,
			max_width = 0.32,
			min_width = 0.32,

			win_opts = {
				cursorline = true,

				-- kitty relies on the space following a double-width icon to
				-- properly render it, but if the window is not opaque, sometimes
				-- another character from behind might take up the space, causing
				-- the icon to be randomly smaller or truncated. See:
				-- https://github.com/kovidgoyal/kitty/issues/6210
				winblend = 0,

				winhighlight = "NormalFloat:KsmaiNormalWithoutBg",
			},
		},
	},
	init = function()
		local palette = require("gruvbox").palette

		-- the default NormalFloat does not play well with CursorLine
		vim.api.nvim_set_hl(0, "KsmaiNormalWithoutBg", {
			fg = palette.light1,
		})
	end,
}
