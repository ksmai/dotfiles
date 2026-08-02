vim.keymap.set("n", "<leader>q", function()
	if vim.fn.empty(vim.fn.filter(vim.fn.getwininfo(), "v:val.quickfix")) == 1 then
		vim.cmd("copen")
	else
		vim.cmd("cclose")
	end
end, { silent = true, desc = "Toggle quickfix list" })

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

			if idx == current and #qflist > 0 then
				local win = vim.api.nvim_get_current_win()
				vim.cmd("cc")
				vim.api.nvim_set_current_win(win)
			end
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
