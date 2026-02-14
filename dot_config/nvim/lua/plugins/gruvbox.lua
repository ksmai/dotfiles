return {
	"ellisonleao/gruvbox.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		vim.o.background = "dark" -- or "light" for light mode
		require("gruvbox").setup({ contrast = "hard" })
		vim.cmd([[colorscheme gruvbox]])
	end,
}
