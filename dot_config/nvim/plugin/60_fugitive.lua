local function is_autodiff(buf)
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

local function read_text(arg)
	if arg == nil or arg == "" then
		arg = ":0:" .. vim.fn["fugitive#Path"](vim.fn.expand("%"), "")
	end

	if arg:sub(1, 11) ~= "fugitive://" then
		arg = vim.fn.FugitiveFind(arg)
	end

	if arg:sub(1, 11) ~= "fugitive://" then
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

local setup_autodiff = function(buf)
	local autodiff, filename = is_autodiff(buf)
	if not autodiff or filename == nil then
		return
	end

	local text = read_text(filename)
	if text == nil then
		return
	end

	MiniDiff.disable(buf)
	MiniDiff.set_ref_text(buf, text)
	MiniDiff.toggle_overlay(buf)
end

vim.keymap.set("n", "<leader>s", function()
	if vim.bo.filetype == "fugitive" then
		return
	end

	vim.cmd("Gedit :")
end, { desc = "Git status" })

vim.keymap.set("n", "<leader>gb", "<cmd>Git blame --date=relative<cr>", { desc = "Git blame" })

vim.keymap.set("n", "<leader>gp", "<cmd>Git log --patch -- %<cr>", { desc = "Git log with patch" })

vim.keymap.set(
	"x",
	"<leader>gp",
	[[<esc><cmd>lua vim.cmd("Git log --patch -L" .. vim.api.nvim_buf_get_mark(0, "<")[1] .. "," .. vim.api.nvim_buf_get_mark(0, ">")[1] .. ":%")<cr>]],
	{ desc = "Git log with patch" }
)

vim.keymap.set("n", "<leader>gh", "<cmd>GBrowse!<cr>", { desc = "Copy GitHub URL" })
vim.keymap.set("n", "<leader>gH", "<cmd>GBrowse<cr>", { desc = "Open in GitHub" })

vim.keymap.set("x", "<leader>gh", ":GBrowse!<cr>", { desc = "Copy GitHub URL (selected lines)" })
vim.keymap.set("x", "<leader>gH", ":GBrowse<cr>", { desc = "Open in Github (selected lines)" })

vim.keymap.set("n", "<leader>gl", function()
	vim.cmd("0Gclog")
end, { desc = "Git log" })

vim.keymap.set("x", "<leader>gl", function()
	local line1 = vim.fn.line("v")
	local line2 = vim.fn.line(".")

	if line1 > line2 then
		line1, line2 = line2, line1
	end
	vim.cmd(string.format("%d,%dGclog", line1, line2))
end, { desc = "Git log (selected lines)" })

vim.keymap.set("n", "<leader>dw", "<cmd>diffoff! | windo diffthis<cr>", { silent = true, desc = "Diff windows" })
vim.keymap.set("n", "<leader>dq", function()
	vim.cmd("diffoff!")
	MiniDiff.disable()
end, { silent = true, desc = "Diff off" })

vim.keymap.set("n", "<C-I>", "<C-I>")
vim.keymap.set("n", "<Tab>", function()
	if vim.wo.diff then
		vim.cmd("normal! ]c")
		return
	end

	local data = MiniDiff.get_buf_data()
	local autodiff = is_autodiff()

	if data ~= nil and #data.hunks > 0 then
		local current = vim.fn.line(".")

		vim.cmd([[silent! lua MiniDiff.goto_hunk("next")]])

		if current ~= vim.fn.line(".") or not autodiff then
			return
		end
	end

	local ok = pcall(vim.cmd, "cnext")
	if ok and autodiff then
		local buf = vim.api.nvim_get_current_buf()
		vim.api.nvim_create_autocmd("User", {
			pattern = "MiniDiffUpdated",
			once = true,
			callback = function(ev)
				if ev.buf ~= buf then
					return
				end
				vim.cmd([[silent! lua MiniDiff.goto_hunk("first")]])
			end,
		})
	end
end, { desc = "Next hunk/quickfix item" })

vim.keymap.set("n", "<S-Tab>", function()
	if vim.wo.diff then
		vim.cmd("normal! [c")
		return
	end

	local data = MiniDiff.get_buf_data()
	local autodiff = is_autodiff()

	if data ~= nil then
		local current = vim.fn.line(".")

		vim.cmd([[silent! lua MiniDiff.goto_hunk("prev")]])

		if current ~= vim.fn.line(".") or not autodiff then
			return
		end
	end

	local ok = pcall(vim.cmd, "cprev")
	if ok and autodiff then
		local buf = vim.api.nvim_get_current_buf()
		vim.api.nvim_create_autocmd("User", {
			pattern = "MiniDiffUpdated",
			once = true,
			callback = function(ev)
				if ev.buf ~= buf then
					return
				end
				vim.cmd([[silent! lua MiniDiff.goto_hunk("last")]])
			end,
		})
	end
end, { desc = "Prev hunk/quickfix item" })

vim.api.nvim_create_user_command("DiffUnified", function(opts)
	local text = read_text(opts.fargs[1])
	if text == nil then
		return
	end

	MiniDiff.disable(0)
	MiniDiff.set_ref_text(0, text)
	MiniDiff.toggle_overlay(0)
end, {
	desc = "Unified diff",
	nargs = "?",
	complete = "customlist,fugitive#EditComplete",
})

vim.api.nvim_create_user_command("DiffTool", function(opts)
	vim.cmd("Git difftool --name-status " .. opts.args)
	setup_autodiff(vim.api.nvim_get_current_buf())
end, {
	desc = "Unified difftool",
	nargs = "*",
	complete = function(_, CmdLine, _)
		return vim.fn.getcompletion("Git difftool --name-status" .. CmdLine:sub(10), "cmdline")
	end,
})

vim.api.nvim_create_user_command("DiffVSplit", function()
	local data = MiniDiff.get_buf_data()
	if data == nil or data.ref_text == nil then
		return
	end

	vim.cmd("diffoff!")

	local current_win = vim.api.nvim_get_current_win()

	local scratch_buf = vim.api.nvim_create_buf(false, true)

	local lines = vim.split(data.ref_text, "\n", { plain = true })
	vim.api.nvim_buf_set_lines(scratch_buf, 0, -1, false, lines)

	vim.cmd("aboveleft vsplit")
	local scratch_win = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(scratch_win, scratch_buf)

	vim.api.nvim_win_call(current_win, function()
		MiniDiff.disable()
		vim.cmd("diffthis")
	end)
	vim.api.nvim_win_call(scratch_win, function()
		vim.cmd("diffthis")
	end)
end, {
	desc = "Split unified diff",
})

vim.api.nvim_create_user_command("Diff4Way", function()
	local win = vim.api.nvim_get_current_win()
	vim.cmd("diffoff!")
	vim.cmd("leftabove Ghdiffsplit :2")
	vim.cmd("rightbelow Gvdiffsplit :3")
	vim.cmd("leftabove Gvdiffsplit :1")
	vim.api.nvim_set_current_win(win)
end, {
	desc = "4 way diff for merge conflicts",
})

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("FugitiveBuffer", { clear = true }),
	pattern = "fugitive",
	callback = function(ev)
		vim.keymap.set("n", "<C-I>", "<C-I>", { buffer = ev.buf })
		vim.keymap.set("n", "<tab>", "]czt<c-y>", { buffer = ev.buf, remap = true })
		vim.keymap.set("n", "<s-tab>", "[czt<c-y>", { buffer = ev.buf, remap = true })
		vim.bo[ev.buf].bufhidden = ""
	end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
	group = vim.api.nvim_create_augroup("FugitiveAutoDiff", { clear = true }),
	callback = function(ev)
		setup_autodiff(ev.buf)
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("QuickfixKeymaps", { clear = true }),
	pattern = "qf",
	callback = function(ev)
		vim.keymap.set("n", "X", function()
			local pos = vim.fn.getpos(".")
			local idx = pos[2]
			local col = pos[3]
			local qflist = vim.fn.getqflist()

			if #qflist < idx then
				return
			end

			local deleted = { idx = idx, entry = qflist[idx] }
			table.remove(qflist, idx)

			local context = vim.fn.getqflist({ context = 0 }).context
			if context == "" then
				context = {}
			end

			if type(context) == "table" and type(context.items) == "table" and #context.items >= idx then
				deleted.item = context.items[idx]
				table.remove(context.items, idx)
			end

			if type(context) == "table" then
				if type(context.delete_history) ~= "table" then
					context.delete_history = {}
				end

				table.insert(context.delete_history, deleted)
			end

			local current = vim.fn.getqflist({ idx = 0 }).idx
			local target = math.min(current, #qflist)
			if idx < current then
				target = current - 1
			end
			vim.fn.setqflist({}, "r", { context = context, items = qflist, idx = target })
			vim.api.nvim_win_set_cursor(0, { math.max(1, math.min(idx, #qflist)), col - 1 })
		end, { buf = ev.buf, desc = "Remove quickfix item" })

		vim.keymap.set("n", "u", function()
			local context = vim.fn.getqflist({ context = 0 }).context

			if type(context) ~= "table" or type(context.delete_history) ~= "table" or #context.delete_history == 0 then
				return
			end

			local qflist = vim.fn.getqflist()
			local deleted = table.remove(context.delete_history)
			table.insert(qflist, deleted.idx, deleted.entry)

			if type(deleted.item) == "table" and type(context.items) == "table" then
				table.insert(context.items, deleted.idx, deleted.item)
			end

			local pos = vim.fn.getpos(".")
			local current = vim.fn.getqflist({ idx = 0 }).idx
			local target = deleted.idx <= current and current + 1 or current
			vim.fn.setqflist({}, "r", { context = context, items = qflist, idx = target })
			vim.api.nvim_win_set_cursor(
				0,
				{ math.max(1, math.min(pos[2] + (deleted.idx <= pos[2] and 1 or 0), #qflist)), pos[3] - 1 }
			)
		end, { buf = ev.buf, desc = "Undo removing quickfix item" })
	end,
})
