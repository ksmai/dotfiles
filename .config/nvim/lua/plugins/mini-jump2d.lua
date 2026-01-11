return {
	"nvim-mini/mini.jump2d",
	version = false,
	keys = {
		{
			"\\",
			function()
				local jump2d = require("mini.jump2d")

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
			end,
			mode = "n",
			silent = true,
			noremap = true,
			desc = "Jump 2D",
		},
	},
	opts = {
		mappings = {
			start_jumping = "",
		},
	},
}
