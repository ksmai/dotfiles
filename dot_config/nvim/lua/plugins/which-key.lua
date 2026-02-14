return {
	"folke/which-key.nvim",
	config = function(_, opts)
		vim.opt.timeout = true
		vim.opt.timeoutlen = 500
		local wk = require("which-key")
		wk.setup(opts)
		wk.add({
			{ "<leader>c", group = "+Code" },
			{ "<leader>d", group = "+Diff / Debug" },
			{ "<leader>f", group = "+Find" },
			{ "<leader>g", group = "+Git" },
			{ "<leader>k", group = "+Kulala" },
			{ "<leader>r", group = "+Run tests" },
		})
	end,
}
