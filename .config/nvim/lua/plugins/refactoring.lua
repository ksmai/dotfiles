return {
	"ThePrimeagen/refactoring.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"nvim-telescope/telescope.nvim",
	},
	keys = {
		{
			"<leader>cR",
			[[<cmd>lua require("telescope").extensions.refactoring.refactors()<cr>]],
			mode = "n",
			noremap = true,
			silent = true,
			desc = "refactor",
		},
		{
			"<leader>cR",
			[[<esc><cmd>lua require("telescope").extensions.refactoring.refactors()<cr>]],
			mode = "v",
			noremap = true,
			silent = true,
			desc = "refactor",
		},
	},
	config = function()
		require("refactoring").setup({})
		require("telescope").load_extension("refactoring")
	end,
}
