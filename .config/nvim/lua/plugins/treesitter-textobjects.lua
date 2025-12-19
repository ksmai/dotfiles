return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	branch = "main",

	keys = {
		{
			"]]",
			function()
				require("nvim-treesitter-textobjects.move").goto_next_start(
					{ "@class.outer", "@function.outer" },
					"textobjects"
				)
			end,
			mode = { "n", "x", "o" },
			silent = true,
			noremap = true,
			desc = "Goto next start",
		},

		{
			"][",
			function()
				require("nvim-treesitter-textobjects.move").goto_next_end(
					{ "@class.outer", "@function.outer" },
					"textobjects"
				)
			end,
			mode = { "n", "x", "o" },
			silent = true,
			noremap = true,
			desc = "Goto next end",
		},

		{
			"[[",
			function()
				require("nvim-treesitter-textobjects.move").goto_previous_start(
					{ "@class.outer", "@function.outer" },
					"textobjects"
				)
			end,
			mode = { "n", "x", "o" },
			silent = true,
			noremap = true,
			desc = "Goto previous start",
		},

		{
			"[]",
			function()
				require("nvim-treesitter-textobjects.move").goto_previous_end(
					{ "@class.outer", "@function.outer" },
					"textobjects"
				)
			end,
			mode = { "n", "x", "o" },
			silent = true,
			noremap = true,
			desc = "Goto previous end",
		},
	},

	opts = {
		move = {
			set_jumps = true,
		},
	},

	init = function()
		-- Disable entire built-in ftplugin mappings to avoid conflicts.
		-- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
		vim.g.no_plugin_maps = true
	end,
}
