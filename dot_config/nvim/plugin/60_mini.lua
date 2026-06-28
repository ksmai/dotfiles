local mini_ai = require("mini.ai")
local jump2d = require("mini.jump2d")
local operators = require("mini.operators")

mini_ai.setup({
	n_lines = 1000,

	custom_textobjects = {
		b = { { "%b()", "%b[]", "%b{}" }, "^.%s*().-()%s*.$" },
		k = mini_ai.gen_spec.function_call(),
		f = mini_ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
		c = mini_ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
	},
})

jump2d.setup({
	mappings = {
		start_jumping = "",
	},
})

operators.setup({})

vim.keymap.set("n", "\\", function()
	local opts = {
		spotter = function()
			return {}
		end,
		allowed_lines = { blank = false, fold = false },
		view = {
			dim = true,
			n_steps_ahead = 10,
		},
	}

	local before_start = function()
		local _, char = pcall(vim.fn.getcharstr)
		if char == nil then
			return
		end

		char = vim.fn.escape(char, "\\")

		if string.match(char, "%l") then
			local upper = string.upper(char)
			char = "\\[" .. char .. upper .. "]"
		end

		opts.spotter = jump2d.gen_spotter.vimpattern([[\V\C]] .. char)
	end
	opts.hooks = { before_start = before_start }

	require("mini.jump2d").start(opts)
end, { desc = "Jump 2D" })
