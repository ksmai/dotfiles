local H = {}

vim.api.nvim_create_autocmd("BufWinEnter", {
	group = vim.api.nvim_create_augroup("FugitiveAutoDiff", { clear = true }),
	callback = function(ev)
		H.handle_autodiff(ev.buf)
	end,
})

vim.api.nvim_create_user_command("DiffUnified", function(opts)
	local text = H.read_text(opts.fargs[1])
	if text == nil then
		return
	end

	H.set_diff_text(0, text)
end, {
	desc = "Unified diff",
	nargs = "?",
	complete = "customlist,fugitive#EditComplete",
})

vim.api.nvim_create_user_command("DiffTool", function(opts)
	vim.cmd("Git difftool --name-status " .. opts.args)
	H.handle_autodiff(vim.api.nvim_get_current_buf())
end, {
	desc = "Unified difftool",
	nargs = "*",
	complete = function(_, CmdLine, _)
		return vim.fn.getcompletion("Git difftool --name-status" .. CmdLine:sub(10), "cmdline")
	end,
})

vim.keymap.set("n", "<C-I>", "<C-I>")

vim.keymap.set("n", "<Tab>", function()
	H.handle_tab({ forward = true })
end, { desc = "Next hunk/quickfix item" })

vim.keymap.set("n", "<S-Tab>", function()
	H.handle_tab({ forward = false })
end, { desc = "Prev hunk/quickfix item" })

H.handle_autodiff = function(buf)
	local autodiff, filename = H.is_autodiff(buf)
	if not autodiff or filename == nil then
		return
	end

	local text = H.read_text(filename)
	if text == nil then
		return
	end

	H.set_diff_text(buf, text)
end

H.set_diff_text = function(buf, text)
	local MiniDiff = require("mini.diff")
	MiniDiff.disable(buf)
	MiniDiff.set_ref_text(buf, text)
	MiniDiff.toggle_overlay(buf)
end

H.is_autodiff = function(buf)
	local qflist = vim.fn.getqflist({ idx = 0, context = 0 })
	local idx = qflist.idx
	local context = qflist.context

	if idx == 0 or type(context) ~= "table" or type(context.items) ~= "table" then
		return false, nil
	end

	local item = context.items[idx]
	if type(item) ~= "table" then
		return false, nil
	end

	if buf == nil or buf == 0 then
		buf = vim.api.nvim_get_current_buf()
	end

	if
		vim.fn.getqflist()[idx].bufnr ~= buf
		or type(item.diff) ~= "table"
		or #item.diff ~= 1
		or type(item.diff[1].filename) ~= "string"
	then
		return true, nil
	end

	return true, item.diff[1].filename
end

H.read_text = function(arg)
	if arg == nil or arg == "" or arg == ":" or arg == ":0" then
		arg = ":0:" .. vim.fn["fugitive#Path"](vim.fn.expand("%"), "")
	end

	if vim.endswith(arg, ":%") then
		arg = arg:gsub("%%$", vim.fn["fugitive#Path"](vim.fn.expand("%"), ""))
	end

	if not vim.startswith(arg, "fugitive://") then
		arg = vim.fn.FugitiveFind(arg)
	end

	if not vim.startswith(arg, "fugitive://") then
		local ok, text = pcall(vim.fn.readblob, arg)
		if not ok then
			return nil
		end
		return text
	end

	if arg:match("//%x+/.+") == nil then
		arg = arg .. (arg:match("/$") == nil and "/" or "") .. vim.fn["fugitive#Path"](vim.fn.expand("%"), "")
	end

	local ok, parsed = pcall(vim.fn.FugitiveParse, arg)
	if not ok or type(parsed) ~= "table" or #parsed < 2 or parsed[1] == "" or parsed[2] == "" then
		return nil
	end

	local result = vim.fn.FugitiveExecute({ "cat-file", "-p", parsed[1] }, parsed[2])

	if result.exit_status ~= 0 then
		return nil
	end

	return result.stdout
end

H.handle_tab = function(opts)
	local forward = opts.forward

	if vim.bo.filetype == "fugitive" then
		H.jump_to_next_hunk_or_file({ forward = forward })
		return
	end

	if vim.wo.diff then
		local cmd = forward and "]c" or "[c"
		vim.cmd("normal! " .. cmd)
		return
	end

	local data = require("mini.diff").get_buf_data()
	local autodiff = H.is_autodiff()

	if data ~= nil and #data.hunks > 0 then
		local current = vim.fn.line(".")
		local dir = forward and "next" or "prev"

		vim.cmd(string.format([[silent! lua MiniDiff.goto_hunk("%s")]], dir))

		if current ~= vim.fn.line(".") or not autodiff then
			return
		end
	end

	local cmd = forward and "cnext" or "cprev"
	local ok = pcall(vim.cmd, cmd)
	if ok and autodiff then
		local buf = vim.api.nvim_get_current_buf()
		vim.api.nvim_create_autocmd("User", {
			group = vim.api.nvim_create_augroup("FugitiveDiffToolTabbing", { clear = true }),
			pattern = "MiniDiffUpdated",
			once = true,
			callback = function(ev)
				if ev.buf ~= buf then
					return
				end
				local dir = forward and "first" or "last"
				vim.cmd(string.format([[silent! lua MiniDiff.goto_hunk("%s")]], dir))
			end,
		})
	end
end

H.jump_to_next_hunk_or_file = function(opts)
	local forward = opts.forward
	local file_pattern = "^[A-Z?] ."
	local hunk_pattern = "^@@ "

	if vim.fn.match(vim.fn.getline("."), file_pattern) ~= -1 and vim.fn.col(".") ~= vim.fn.col("$") - 1 then
		if forward then
			vim.cmd.normal("i")
		else
			vim.cmd.normal("<[c")
		end
		vim.cmd.normal("zt")
		return
	end

	local flags = "nW"
	if not forward then
		flags = flags .. "b"
	end

	local file_line = vim.fn.search(file_pattern, flags)
	local hunk_line = vim.fn.search(hunk_pattern, flags)
	local diff = hunk_line - file_line
	if not forward then
		diff = -diff
	end

	if diff == 0 then
		vim.cmd.normal("<$")
	elseif file_line == 0 or (hunk_line > 0 and diff < 0) then
		if forward then
			vim.cmd.normal("]c")
		else
			vim.cmd.normal("[c")
		end
	else
		if forward then
			vim.cmd.normal("]m")
		else
			local line = vim.api.nvim_win_get_cursor(0)[1]
			vim.cmd.normal({ "<" })
			if line == vim.api.nvim_win_get_cursor(0)[1] then
				vim.cmd.normal("[c")
			end
		end
	end

	vim.cmd.normal("zt")
end
