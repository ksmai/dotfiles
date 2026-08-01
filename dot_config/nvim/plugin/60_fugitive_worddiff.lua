local augroup = vim.api.nvim_create_augroup("FugitiveWorddiff", { clear = true })
local ns = vim.api.nvim_create_namespace("FugitiveWorddiff")
local timer = vim.uv.new_timer()

local cache = {}
local bufs_to_update = {}
local H = {}

vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = "fugitive",
	callback = function(ev)
		H.enable(ev.buf)
	end,
})

vim.api.nvim_set_decoration_provider(ns, {
	on_win = function(_, _, buf, top, bottom)
		if not cache[buf] then
			return false
		end

		if cache[buf].needs_clear then
			H.clear_all_hl(buf)
			cache[buf].needs_clear = false
		end

		local hl_ranges = cache[buf].hl_ranges

		for i = top, bottom do
			if hl_ranges[i] then
				for _, data in ipairs(hl_ranges[i]) do
					vim.hl.range(
						buf,
						ns,
						data.hl,
						{ i, data.start_col },
						{ i, data.end_col },
						{ inclusive = true, priority = 199 }
					)
				end
				hl_ranges[i] = nil
			end
		end
	end,
})

H.enable = function(buf)
	if H.should_disable(buf) or cache[buf] then
		return
	end

	cache[buf] = {
		hl_ranges = {},
		needs_clear = false,
		augroup = vim.api.nvim_create_augroup("FugitiveWorddiff_" .. buf, { clear = true }),
	}

	vim.api.nvim_create_autocmd("TextChanged", {
		group = cache[buf].augroup,
		buffer = buf,
		callback = function()
			H.schedule_diff_update(buf)
		end,
	})

	vim.api.nvim_create_autocmd("FileType", {
		group = cache[buf].augroup,
		buffer = buf,
		callback = function(ev)
			if H.should_disable(ev.buf) then
				H.disable(ev.buf)
			end
		end,
	})

	vim.api.nvim_create_autocmd("BufUnload", {
		group = cache[buf].augroup,
		buffer = buf,
		callback = function(ev)
			H.disable(ev.buf)
		end,
	})

	H.schedule_diff_update(buf)
end

H.disable = function(buf)
	if not cache[buf] then
		return
	end

	vim.api.nvim_del_augroup_by_id(cache[buf].augroup)
	cache[buf] = nil
	H.clear_all_hl(buf)
end

H.should_disable = function(buf)
	return not vim.api.nvim_buf_is_valid(buf)
		or not vim.api.nvim_buf_is_loaded(buf)
		or vim.bo[buf].filetype ~= "fugitive"
end

H.schedule_diff_update = function(buf)
	bufs_to_update[buf] = true

	if timer then
		timer:stop()
		timer:start(100, 0, H.process_scheduled_buffers)
	end
end

H.process_scheduled_buffers = vim.schedule_wrap(function()
	for buf, _ in pairs(bufs_to_update) do
		H.update_buf_diff(buf)
	end
	bufs_to_update = {}
end)

H.update_buf_diff = function(buf)
	if not cache[buf] then
		return
	end

	if H.should_disable(buf) then
		H.disable(buf)
		return
	end

	local diff_groups = H.parse_diff_groups(buf)
	cache[buf].hl_ranges = H.compute_hl_ranges(diff_groups)
	cache[buf].needs_clear = true

	vim.cmd.redraw({ bang = true })
end

H.parse_diff_groups = function(buf)
	local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
	local diff_groups = {}
	local cur_group = nil

	local insert_cur_group = function()
		if
			cur_group
			and cur_group.old.start
			and cur_group.new.start
			and #cur_group.old.lines <= 60
			and #cur_group.new.lines <= 60
		then
			table.insert(diff_groups, cur_group)
		end
		cur_group = nil
	end

	for i, line in ipairs(lines) do
		local char = line:sub(1, 1)

		if char ~= "-" and char ~= "+" then
			insert_cur_group()
		elseif char ~= "+" or cur_group then
			if char == "-" and cur_group and cur_group.new.start then
				insert_cur_group()
			end

			if not cur_group then
				cur_group = { old = { start = nil, lines = {} }, new = { start = nil, lines = {} } }
			end

			local to_insert = char == "-" and cur_group.old or cur_group.new
			table.insert(to_insert.lines, line:sub(2))

			if not to_insert.start then
				to_insert.start = i - 1
			end
		end
	end

	insert_cur_group()

	return diff_groups
end

H.compute_hl_ranges = function(diff_groups)
	local hl_ranges = {}

	for _, diff_group in ipairs(diff_groups) do
		local line_diffs =
			vim.text.diff(table.concat(diff_group.old.lines, "\n"), table.concat(diff_group.new.lines, "\n"), {
				algorithm = "histogram",
				result_type = "indices",
				ctxlen = 0,
				indent_heuristic = true,
				linematch = true,
			})

		for _, line_diff in ipairs(line_diffs) do
			local old_start, old_count, new_start, new_count = unpack(line_diff)
			if old_count == new_count then
				for offset = 0, new_count - 1 do
					local old_line = diff_group.old.lines[old_start + offset]
					local new_line = diff_group.new.lines[new_start + offset]
					local old_ranges, new_ranges = H.compute_worddiff(old_line, new_line)
					local old_row = diff_group.old.start + old_start + offset - 1
					local new_row = diff_group.new.start + new_start + offset - 1

					for _, range in ipairs(old_ranges) do
						if not hl_ranges[old_row] then
							hl_ranges[old_row] = {}
						end

						table.insert(hl_ranges[old_row], {
							hl = "DiffTextDelete",
							start_col = range[1],
							end_col = range[2],
						})
					end

					for _, range in ipairs(new_ranges) do
						if not hl_ranges[new_row] then
							hl_ranges[new_row] = {}
						end

						table.insert(hl_ranges[new_row], {
							hl = "DiffTextAdd",
							start_col = range[1],
							end_col = range[2],
						})
					end
				end
			end
		end
	end

	return hl_ranges
end

H.compute_worddiff = function(old_line, new_line)
	local old_sliced, old_byte_starts, old_byte_ends = H.slice_line(old_line)
	local new_sliced, new_byte_starts, new_byte_ends = H.slice_line(new_line)
	local diff = vim.text.diff(old_sliced, new_sliced, {
		algorithm = "minimal",
		result_type = "indices",
		ctxlen = 0,
		interhunkctxlen = 4,
		indent_heuristic = false,
		linematch = 0,
	})

	local old_ranges, new_ranges = {}, {}

	for _, d in ipairs(diff) do
		if d[2] > 0 then
			table.insert(old_ranges, { old_byte_starts[d[1]], old_byte_ends[d[1] + d[2] - 1] })
		end

		if d[4] > 0 then
			table.insert(new_ranges, { new_byte_starts[d[3]], new_byte_ends[d[3] + d[4] - 1] })
		end
	end

	return old_ranges, new_ranges
end

H.slice_line = function(line)
	local sliced = {}
	local byte_starts = vim.str_utf_pos(line)
	local byte_ends = {}

	for i = 1, #byte_starts - 1 do
		table.insert(sliced, line:sub(byte_starts[i], byte_starts[i + 1] - 1))
		table.insert(byte_ends, byte_starts[i + 1] - 1)
	end

	table.insert(sliced, line:sub(byte_starts[#byte_starts], line:len()))
	table.insert(byte_ends, line:len())

	return table.concat(sliced, "\n") .. "\n", byte_starts, byte_ends
end

H.clear_all_hl = function(buf)
	vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
end
