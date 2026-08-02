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
	vim.bo[scratch_buf].filetype = vim.bo.filetype

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
		vim.bo[ev.buf].bufhidden = ""
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
