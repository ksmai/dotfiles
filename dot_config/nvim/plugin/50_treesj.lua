vim.keymap.set("n", "<leader>cj", "<cmd>TSJToggle<cr>", { desc = "Toggle treesj" })

require("treesj").setup({
	use_default_keymaps = false,
	max_join_length = 1200,
})
