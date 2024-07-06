return {
	"folke/trouble.nvim",
	keys = {
		{
			"<leader>fx",
			"<cmd>TroubleToggle workspace_diagnostics<cr>",
			mode = "n",
			noremap = true,
			silent = true,
			desc = "Toggle workspace diagnostics",
		},
	},
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {},
}
