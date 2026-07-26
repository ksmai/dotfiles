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
	local general_repeatable_move_fn = function(opts, ...)
		if opts.forward then
			forward_move_fn(...)
		else
			backward_move_fn(...)
		end
	end

	local repeatable_forward_move_fn = function(...)
		ts_repeat_move.last_move =
			{ func = general_repeatable_move_fn, opts = { forward = true }, additional_args = { ... } }
		forward_move_fn(...)
	end

	local repeatable_backward_move_fn = function(...)
		ts_repeat_move.last_move =
			{ func = general_repeatable_move_fn, opts = { forward = false }, additional_args = { ... } }
		backward_move_fn(...)
	end

	return repeatable_forward_move_fn, repeatable_backward_move_fn
end

local make_repeatable_keymap_pair = function(forward_lhs, backward_lhs)
	local forward_maparg = vim.fn.maparg(forward_lhs, "n", false, true)
	local backward_maparg = vim.fn.maparg(backward_lhs, "n", false, true)

	local get_callback = function(maparg)
		if maparg.callback then
			return maparg.callback
		end

		if not maparg.rhs then
			error("no rhs for " .. maparg.lhs, vim.log.levels.ERROR)
		end

		return function()
			local keys = vim.keycode(maparg.rhs)
			local feed_mode = maparg.noremap == 1 and "n" or "m"
			vim.api.nvim_feedkeys(keys, feed_mode, false)
		end
	end

	local forward_callback, backward_callback =
		make_repeatable_move_pair(get_callback(forward_maparg), get_callback(backward_maparg))
	vim.fn.mapset("n", false, vim.tbl_deep_extend("force", forward_maparg, { callback = forward_callback }))
	vim.fn.mapset("n", false, vim.tbl_deep_extend("force", backward_maparg, { callback = backward_callback }))
end

make_repeatable_keymap_pair("]d", "[d")
make_repeatable_keymap_pair("]q", "[q")
make_repeatable_keymap_pair("]<C-Q>", "[<C-Q>")
make_repeatable_keymap_pair("]l", "[l")
make_repeatable_keymap_pair("]<C-L>", "[<C-L>")
make_repeatable_keymap_pair("]h", "[h")
make_repeatable_keymap_pair("]n", "[n")
make_repeatable_keymap_pair("]x", "[x")

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
