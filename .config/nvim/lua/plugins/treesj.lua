return {
	"Wansmer/treesj",
	keys = {
		{
			"<leader>cj",
			"<cmd>TSJToggle<cr>",
			mode = "n",
			silent = true,
			noremap = true,
			desc = "Toggle treesj",
		},
	},
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	config = function()
		require("treesj").setup({
			use_default_keymaps = false,
			max_join_length = 1200,
		})
	end,
}
