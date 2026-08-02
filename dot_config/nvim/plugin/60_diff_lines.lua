local H = {}
local cache = {}
local ns = vim.api.nvim_create_namespace("diff_lines")
local stop_lhs = "<C-c>"

vim.api.nvim_create_user_command("DiffLines", function(opts)
	H.handle_diff_lines(opts.line1, opts.line2)
end, {
	range = true,
})

vim.keymap.set("n", "gzd", function()
	local set_opfunc = vim.fn[vim.api.nvim_exec2(
		[[
			func s:set_opfunc(val)
				let &opfunc = a:val
			endfunc
			echon get(function('s:set_opfunc'), 'name')
		]],
		{ output = true }
	).output]
	set_opfunc(H.operatorfunc)
	return "g@"
end, { expr = true, desc = "DiffLines" })

vim.keymap.set("n", "gzdd", "gzd_", { remap = true, desc = "DiffLines current line" })

vim.keymap.set("x", "gzd", function()
	vim.cmd.normal({ "\27", bang = true })
	local line1 = vim.api.nvim_buf_get_mark(0, "<")[1]
	local line2 = vim.api.nvim_buf_get_mark(0, ">")[1]
	H.handle_diff_lines(line1, line2)
end, { desc = "DiffLines selected lines" })

H.operatorfunc = function()
	local line1 = vim.api.nvim_buf_get_mark(0, "[")[1]
	local line2 = vim.api.nvim_buf_get_mark(0, "]")[1]
	H.handle_diff_lines(line1, line2)
end

H.handle_diff_lines = function(line1, line2)
	if not H.has_step_one() then
		cache.step_one = H.set_extmark(line1 - 1, line2 - 1)
		H.set_stop_mapping()
	else
		H.show_diff(line1 - 1, line2 - 1)
		H.stop()
	end
end

H.has_step_one = function()
	if not cache.step_one then
		return false
	end

	if not vim.api.nvim_buf_is_valid(cache.step_one.buf) then
		H.stop()
		return false
	end

	return true
end

H.stop = function()
	H.del_stop_mapping()

	if cache.step_one then
		vim.api.nvim_buf_clear_namespace(cache.step_one.buf, ns, 0, -1)
	end

	cache = {}
end

H.set_stop_mapping = function()
	cache.maparg = vim.fn.maparg(stop_lhs, "n", false, true)
	vim.keymap.set("n", stop_lhs, H.stop, { desc = "Stop DiffLines" })
end

H.del_stop_mapping = function()
	if not cache.maparg then
		return
	end

	if vim.tbl_count(cache.maparg) > 0 then
		vim.fn.mapset("n", false, cache.maparg)
	else
		vim.keymap.del("n", stop_lhs)
	end
end

H.set_extmark = function(row1, row2)
	local buf = vim.api.nvim_get_current_buf()

	local extmark = vim.api.nvim_buf_set_extmark(buf, ns, row1, 0, {
		end_row = row2 + 1,
		end_col = 0,
		hl_group = "IncSearch",
		hl_eol = true,
		right_gravity = false,
	})

	return { buf = buf, extmark = extmark }
end

H.show_diff = function(row1, row2)
	local extmark =
		vim.api.nvim_buf_get_extmark_by_id(cache.step_one.buf, ns, cache.step_one.extmark, { details = true })

	local ref_text = vim.api.nvim_buf_get_lines(cache.step_one.buf, extmark[1], extmark[3].end_row, false)
	local buf_text = vim.api.nvim_buf_get_lines(0, row1, row2 + 1, false)

	local buf = vim.api.nvim_create_buf(false, true)

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, buf_text)
	vim.bo[buf].filetype = vim.bo.filetype
	vim.api.nvim_win_set_buf(0, buf)

	local MiniDiff = require("mini.diff")
	MiniDiff.disable(buf)
	MiniDiff.set_ref_text(buf, ref_text)
	MiniDiff.toggle_overlay(buf)
end
