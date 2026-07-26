local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")

vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)
vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })

-- https://github.com/kiyoon/repeatable-move.nvim
local make_repeatable_move_pair = function(forward_move_fn, backward_move_fn)
	local move_fn = ts_repeat_move.make_repeatable_move(function(opts, ...)
		if opts.forward then
			forward_move_fn(...)
		else
			backward_move_fn(...)
		end
	end)

	local make_move_fn = function(forward)
		return function(...)
			move_fn({ forward = forward }, ...)
		end
	end

	return make_move_fn(true), make_move_fn(false)
end

local make_repeatable_keymap_pair = function(forward_lhs, backward_lhs)
	local forward_maparg = vim.fn.maparg(forward_lhs, "n", false, true)
	local backward_maparg = vim.fn.maparg(backward_lhs, "n", false, true)

	local assert_not_buffer_local = function(lhs, maparg)
		if not vim.tbl_isempty(maparg) and maparg.buffer ~= 0 then
			error("buffer local keymaps are not supported " .. lhs, vim.log.levels.ERROR)
		end
	end

	assert_not_buffer_local(forward_lhs, forward_maparg)
	assert_not_buffer_local(backward_lhs, backward_maparg)

	local get_callback = function(lhs, maparg)
		if maparg.callback then
			return maparg.callback
		end

		if not maparg.rhs then
			local keys = vim.keycode(lhs)
			return function()
				vim.api.nvim_feedkeys(keys, "n", false)
			end
		end

		local keys = vim.keycode(maparg.rhs)
		local feed_mode = maparg.noremap == 1 and "n" or "m"
		return function()
			vim.api.nvim_feedkeys(keys, feed_mode, false)
		end
	end

	local forward_callback, backward_callback = make_repeatable_move_pair(
		get_callback(forward_lhs, forward_maparg),
		get_callback(backward_lhs, backward_maparg)
	)

	local set_keymap = function(lhs, maparg, callback)
		vim.keymap.set("n", lhs, callback, {
			desc = maparg.desc,
			expr = maparg.expr == 1,
			silent = maparg.silent == 1,
		})
	end

	set_keymap(forward_lhs, forward_maparg, forward_callback)
	set_keymap(backward_lhs, backward_maparg, backward_callback)
end

local keymap_pairs = {
	{ "]d", "[d" },
	{ "]q", "[q" },
	{ "]<C-Q>", "[<C-Q>" },
	{ "]l", "[l" },
	{ "]<C-L>", "[<C-L>" },
	{ "]h", "[h" },
	{ "]n", "[n" },
	{ "]x", "[x" },
	{ "<tab>", "<s-tab>" },
	{ "<c-i>", "<c-o>" },
}
for _, pair in ipairs(keymap_pairs) do
	make_repeatable_keymap_pair(pair[1], pair[2])
end
