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
		vim.keymap.set("n", "<C-I>", "<C-I>", { buffer = ev.buf })
		vim.keymap.set("n", "<tab>", "]czt<c-y>", { buffer = ev.buf, remap = true })
		vim.keymap.set("n", "<s-tab>", "[czt<c-y>", { buffer = ev.buf, remap = true })
		vim.bo[ev.buf].bufhidden = ""
	end,
})

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

local function is_autodiff(buf)
	local qflist = vim.fn.getqflist({ idx = 0, context = 0 })
	local idx = qflist.idx
	local context = qflist.context

	if idx == 0 or type(context) ~= "table" or type(context.items) ~= "table" then
		return false, ""
	end

	if buf == nil or buf == 0 then
		buf = vim.api.nvim_get_current_buf()
	end
	if vim.fn.getqflist()[idx].bufnr ~= buf then
		return
	end

	local item = context.items[idx]
	if
		type(item) ~= "table"
		or type(item.diff) ~= "table"
		or #item.diff ~= 1
		or type(item.diff[1].filename) ~= "string"
	then
		return false, ""
	end

	return true, item.diff[1].filename
end

local function read_fugitive_file(filename)
	local ok, parsed = pcall(vim.fn.FugitiveParse, filename)
	if not ok or type(parsed) ~= "table" or #parsed < 2 or parsed[1] == "" or parsed[2] == "" then
		return nil
	end

	local result = vim.system({ "git", "cat-file", "-p", parsed[1] }, {
		cwd = vim.fs.dirname(parsed[2]),
		text = true,
	}):wait()

	if result.code ~= 0 then
		return nil
	end

	return result.stdout
end

vim.api.nvim_create_autocmd("BufWinEnter", {
	group = vim.api.nvim_create_augroup("FugitiveAutoDiff", { clear = true }),
	callback = function(ev)
		local autodiff, filename = is_autodiff(ev.buf)
		if not autodiff then
			return
		end

		local text = read_fugitive_file(filename)
		if text == nil then
			return
		end

		MiniDiff.disable(ev.buf)
		MiniDiff.set_ref_text(ev.buf, text)
		MiniDiff.toggle_overlay(ev.buf)
	end,
})

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

	if data ~= nil then
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
