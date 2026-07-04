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

local autodiff = false

vim.api.nvim_create_user_command("AutoDiff", function(opts)
	if opts.fargs[1] == nil or opts.fargs[1] == "toggle" then
		autodiff = not autodiff
	elseif opts.fargs[1] == "on" then
		autodiff = true
	elseif opts.fargs[1] == "off" then
		autodiff = false
	else
		vim.notify("Invalid arg for AutoDiff (on | off | toggle)")
	end
end, {
	desc = "Toggle autodiff for Fugitive difftool",
	nargs = "?",
	complete = function()
		return { "on", "off", "toggle" }
	end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
	group = vim.api.nvim_create_augroup("FugitiveAutoDiff", { clear = true }),
	callback = function(ev)
		if not autodiff then
			return
		end

		local idx = vim.fn.getqflist({ idx = 0 }).idx
		if idx == 0 then
			return
		end

		if vim.fn.getqflist()[idx].bufnr ~= ev.buf then
			return
		end

		local context = vim.fn.getqflist({ context = 0 }).context
		if type(context) ~= "table" or type(context.items) ~= "table" then
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

		local current_win = vim.api.nvim_get_current_win()

		vim.schedule(function()
			if current_win ~= vim.api.nvim_get_current_win() then
				return
			end

			if ev.buf ~= vim.api.nvim_get_current_buf() then
				return
			end

			local wins = vim.api.nvim_tabpage_list_wins(0)

			for _, win in ipairs(wins) do
				if win ~= current_win and vim.fn.win_gettype(win) ~= "quickfix" then
					vim.api.nvim_win_close(win, false)
				end
			end

			vim.cmd("leftabove Gvdiffsplit " .. parsed[1])
			vim.api.nvim_set_current_win(current_win)
		end)
	end,
})
