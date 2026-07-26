-- Disable entire built-in ftplugin mappings to avoid conflicts.
-- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
vim.g.no_plugin_maps = true

vim.hl.priorities.semantic_tokens = 95

local nvim_treesitter = require("nvim-treesitter")
local ts_move = require("nvim-treesitter-textobjects.move")
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

require("nvim-treesitter-textobjects").setup({
	move = {
		set_jumps = true,
	},
})

vim.keymap.set({ "n", "x", "o" }, "]]", function()
	ts_move.goto_next_start({ "@class.outer", "@function.outer" }, "textobjects")
end, { desc = "Goto next start of a class/function" })

vim.keymap.set({ "n", "x", "o" }, "][", function()
	ts_move.goto_next_end({ "@class.outer", "@function.outer" }, "textobjects")
end, { desc = "Goto next end of a class/function" })

vim.keymap.set({ "n", "x", "o" }, "[[", function()
	ts_move.goto_previous_start({ "@class.outer", "@function.outer" }, "textobjects")
end, { desc = "Goto previous start of a class/function" })

vim.keymap.set({ "n", "x", "o" }, "[]", function()
	ts_move.goto_previous_end({ "@class.outer", "@function.outer" }, "textobjects")
end, { desc = "Goto previous end of a class/function" })

vim.keymap.set({ "n", "x", "o" }, "]}", function()
	ts_move.goto_next_start({ "@block.inner" }, "textobjects")
end, { desc = "Goto next start of a block" })

vim.keymap.set({ "n", "x", "o" }, "]{", function()
	ts_move.goto_next_end({ "@block.inner" }, "textobjects")
end, { desc = "Goto next end of a block" })

vim.keymap.set({ "n", "x", "o" }, "[{", function()
	ts_move.goto_previous_start({ "@block.inner" }, "textobjects")
end, { desc = "Goto previous start of a block" })

vim.keymap.set({ "n", "x", "o" }, "[}", function()
	ts_move.goto_previous_end({ "@block.inner" }, "textobjects")
end, { desc = "Goto previous end of a block" })

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("SetupTreesitter", { clear = true }),

	callback = function(args)
		local lang = vim.treesitter.language.get_lang(args.match) or args.match
		local buf = args.buf

		-- disable in minified files
		local line_count = vim.api.nvim_buf_line_count(buf)
		local file_size = vim.api.nvim_buf_get_offset(buf, line_count)
		if file_size / line_count > 10000 then
			vim.notify("[treesitter] ignoring minified file", vim.log.levels.WARN)
			return
		end

		if vim.tbl_contains(nvim_treesitter.get_installed(), lang) then
		elseif vim.tbl_contains(nvim_treesitter.get_available(), lang) then
			local choice = vim.fn.confirm("Install treesitter parser for " .. lang .. " ?", "&Yes\n&No", 1)
			if choice == 1 then
				nvim_treesitter.install({ lang })
			end
		else
		end

		if vim.treesitter.query.get(lang, "highlights") then
			vim.treesitter.start(buf, lang)
		end

		if vim.treesitter.query.get(lang, "folds") then
			vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
			vim.wo[0][0].foldmethod = "expr"
			vim.wo[0][0].foldlevel = 99
		end

		if vim.treesitter.query.get(lang, "indents") then
			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end
	end,
})
