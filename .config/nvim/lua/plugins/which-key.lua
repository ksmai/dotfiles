return {
	"folke/which-key.nvim",
	config = function(_, opts)
		vim.opt.timeout = true
		vim.opt.timeoutlen = 500
		local wk = require("which-key")
		wk.setup(opts)
		wk.register({
			["<leader>c"] = { name = "+Code" },
			["<leader>d"] = { name = "+Diff / Debug" },
			["<leader>f"] = { name = "+Find" },
			["<leader>g"] = { name = "+Git" },
			["<leader>r"] = { name = "+Run tests" },
			["<leader>t"] = { name = "+Term" },
		})
	end,
}
