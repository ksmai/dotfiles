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
