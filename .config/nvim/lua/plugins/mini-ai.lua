return {
	"nvim-mini/mini.ai",
	-- After this commit: https://github.com/nvim-mini/mini.ai/commit/e66a71449bdf719b4b9c96e0cd7b7d6cc4112f88
	-- @function.outer might match multiple functions in python at the same
	-- time if there are function decorators in the code, so we temporarily
	-- switch to the stable branch until it is resolved. If the stable branch
	-- later also has this issue, please switch to tag v0.16.0.
	-- version = false,
	branch = "stable",
	dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
	config = function()
		local mini_ai = require("mini.ai")
		mini_ai.setup({
			n_lines = 1000,

			custom_textobjects = {
				g = mini_ai.gen_spec.function_call(),

				f = mini_ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
				c = mini_ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
			},
		})
	end,
}
