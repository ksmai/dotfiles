return {
	"nvim-mini/mini.ai",
	version = false,
	dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
	config = function()
		local mini_ai = require("mini.ai")
		mini_ai.setup({
			n_lines = 1000,

			custom_textobjects = {
				b = { { "%b()", "%b[]", "%b{}" }, "^.%s*().-()%s*.$" },
				k = mini_ai.gen_spec.function_call(),
				f = mini_ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
				c = mini_ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
			},
		})
	end,
}
