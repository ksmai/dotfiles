local MiniJump2d = require("mini.jump2d")

MiniJump2d.setup({
	mappings = {
		start_jumping = "",
	},
})

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

		opts.spotter = MiniJump2d.gen_spotter.vimpattern([[\V\C]] .. char)
	end
	opts.hooks = { before_start = before_start }

	MiniJump2d.start(opts)
end, { desc = "Jump 2D" })
