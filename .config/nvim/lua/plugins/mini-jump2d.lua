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

					local edge_only = string.match(char, "[%l%d]")
					char = vim.fn.escape(char, "\\")

					local pat = {
						[[\V\C\(]],
					}

					if string.match(char, "%l") then
						local upper = string.upper(char)
						table.insert(pat, upper)
						table.insert(pat, "\\|")
						char = "\\[" .. char .. upper .. "]"
					end

					if edge_only then
						table.insert(pat, [[\(\<\|_\+\)\zs]])
						table.insert(pat, char)
						table.insert(pat, [[\|]])
						table.insert(pat, char)
						table.insert(pat, [[\ze_\*\>]])
					else
						table.insert(pat, char)
					end

					table.insert(pat, [[\)]])

					opts.spotter = jump2d.gen_spotter.vimpattern(table.concat(pat))
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
