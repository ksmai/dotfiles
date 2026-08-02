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
