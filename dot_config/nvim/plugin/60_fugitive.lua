vim.keymap.set("n", "<leader>s", function()
	if vim.bo.filetype == "fugitive" then
		return
	end

	vim.cmd("Gedit :")
end, { desc = "Git status" })

vim.keymap.set("n", "<leader>gd", "<cmd>Gvdiffsplit !^<cr><C-w>R", { desc = "Git diff against parent" })

vim.keymap.set("n", "<leader>gl", "<cmd>0Gclog<cr>", { desc = "Git log" })

vim.keymap.set("x", "<leader>gl", ":Gclog<cr>", { desc = "Git log (selected lines)" })

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

vim.api.nvim_create_user_command("DiffTool", function(opts)
	vim.cmd("Git difftool --name-status " .. opts.args)

	local qflist = vim.fn.getqflist({ id = 0, context = 0 })
	qflist.context.autodiff = true
	vim.fn.setqflist({}, "r", { id = qflist.id, context = qflist.context })
	vim.api.nvim_exec_autocmds("BufWinEnter", { buf = vim.api.nvim_get_current_buf() })
end, { nargs = "*" })

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
