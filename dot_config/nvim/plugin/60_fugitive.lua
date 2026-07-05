vim.keymap.set("n", "<leader>s", function()
	if vim.bo.filetype == "fugitive" then
		return
	end

	vim.cmd("Gedit :")
end, { desc = "Git status" })

vim.keymap.set("n", "<leader>gd", "<cmd>Gvdiffsplit !^<cr><C-w>R", { desc = "Git diff against parent" })

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

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("FugitiveBuffer", { clear = true }),
	pattern = "fugitive",
	callback = function(ev)
		vim.keymap.set("n", "<tab>", "]czt<c-y>", { buffer = ev.buf, remap = true })
		vim.keymap.set("n", "<s-tab>", "[czt<c-y>", { buffer = ev.buf, remap = true })
		vim.bo[ev.buf].bufhidden = ""
	end,
})

local function start_autodiff()
	local qflist = vim.fn.getqflist({ id = 0, context = 0 })
	qflist.context.autodiff = true
	vim.fn.setqflist({}, "r", { id = qflist.id, context = qflist.context })
	vim.api.nvim_exec_autocmds("BufWinEnter", { buf = vim.api.nvim_get_current_buf() })
end

vim.keymap.set("n", "<leader>gl", function()
	vim.cmd("0Gclog")
	start_autodiff()
end, { desc = "Git log" })

vim.keymap.set("x", "<leader>gl", function()
	local line1 = vim.fn.line("v")
	local line2 = vim.fn.line(".")

	if line1 > line2 then
		line1, line2 = line2, line1
	end
	vim.cmd(string.format("%d,%dGclog", line1, line2))

	start_autodiff()
end, { desc = "Git log (selected lines)" })

vim.api.nvim_create_user_command("AutoDiff", function(opts)
	vim.cmd("Git difftool --name-status " .. opts.args)
	start_autodiff()
end, {
	nargs = "*",
	complete = function(_, CmdLine, _)
		return vim.fn.getcompletion("Git difftool " .. CmdLine:sub(10), "cmdline")
	end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
	group = vim.api.nvim_create_augroup("FugitiveAutoDiff", { clear = true }),
	callback = function(ev)
		local buf = ev.buf
		local win = vim.api.nvim_get_current_win()
		local qflist = vim.fn.getqflist({ id = 0, idx = 0, context = 0 })
		local id = qflist.id
		local idx = qflist.idx
		local context = qflist.context
		local split = context.split

		if
			idx == 0
			or vim.fn.getqflist()[idx].bufnr ~= buf
			or type(context) ~= "table"
			or not context.autodiff
			or type(context.items) ~= "table"
		then
			return
		end

		local item = context.items[idx]
		if
			type(item) ~= "table"
			or type(item.diff) ~= "table"
			or #item.diff ~= 1
			or type(item.diff[1].filename) ~= "string"
		then
			return
		end

		local ok, parsed = pcall(vim.fn.FugitiveParse, item.diff[1].filename)
		if not ok or type(parsed) ~= "table" or #parsed < 1 or parsed[1] == "" then
			return
		end

		vim.schedule(function()
			if win ~= vim.api.nvim_get_current_win() then
				return
			end

			if buf ~= vim.api.nvim_get_current_buf() then
				return
			end

			vim.cmd("diffoff!")

			if
				split ~= nil
				and split ~= win
				and vim.api.nvim_win_is_valid(split)
				and vim.api.nvim_win_get_tabpage(split) == vim.api.nvim_get_current_tabpage()
			then
				vim.cmd("diffthis")

				vim.api.nvim_win_call(split, function()
					vim.cmd("silent Gedit " .. parsed[1])
					vim.cmd("diffthis")
				end)
			else
				local wins = vim.api.nvim_tabpage_list_wins(0)

				for _, w in ipairs(wins) do
					if w ~= win and vim.fn.win_gettype(w) ~= "quickfix" then
						vim.api.nvim_win_close(w, false)
					end
				end

				vim.cmd("leftabove Gvdiffsplit " .. parsed[1])
				context.split = vim.api.nvim_get_current_win()
				vim.fn.setqflist({}, "r", { id = id, context = context })
				vim.api.nvim_set_current_win(win)
			end
		end)
	end,
})

vim.keymap.set("n", "<leader>dw", "<cmd>diffoff! | windo diffthis<cr>", { silent = true, desc = "Diff windows" })
vim.keymap.set("n", "<leader>dq", function()
	vim.cmd("diffoff!")

	local qflist = vim.fn.getqflist({ id = 0, context = 0 })
	if type(qflist.context) == "table" and qflist.context.autodiff then
		local split = qflist.context.split
		if vim.api.nvim_win_is_valid(split) then
			vim.api.nvim_win_close(split, false)
		end

		vim.fn.setqflist({}, "f", { id = qflist.id })
		vim.cmd("cclose")
	end
end, { silent = true, desc = "Diff off" })

vim.keymap.set("n", "<Tab>", function()
	if vim.wo.diff then
		local current = vim.fn.line(".")
		vim.cmd("normal! ]c")

		if current ~= vim.fn.line(".") then
			return
		end

		local context = vim.fn.getqflist({ context = 0 }).context
		if type(context) ~= "table" or not context.autodiff then
			return
		end
	end

	local ok = pcall(vim.cmd, "cnext")
	if ok then
		vim.schedule(function()
			if vim.wo.diff then
				local on_hunk = vim.fn.diff_hlID(".", 1) > 0
				if not on_hunk then
					vim.cmd("normal! ]c")
				end
			end
		end)
	end
end, { desc = "Next hunk/quickfix item" })

vim.keymap.set("n", "<S-Tab>", function()
	if vim.wo.diff then
		local current = vim.fn.line(".")
		vim.cmd("normal! [c")

		if current ~= vim.fn.line(".") then
			return
		end

		local context = vim.fn.getqflist({ context = 0 }).context
		if type(context) ~= "table" or not context.autodiff then
			return
		end
	end

	local ok = pcall(vim.cmd, "cprev")

	if ok then
		vim.schedule(function()
			if vim.wo.diff then
				vim.cmd("normal! G")
				vim.cmd("normal! [c")
			end
		end)
	end
end, { desc = "Prev hunk/quickfix item" })

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
		end, { desc = "Undo removing quickfix item" })
	end,
})
