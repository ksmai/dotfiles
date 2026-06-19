vim.keymap.set("n", "<leader>s", function()
	local wins = vim.api.nvim_list_wins()
	local current_tabpage = vim.api.nvim_get_current_tabpage()

	for _, win in ipairs(wins) do
		local buf = vim.api.nvim_win_get_buf(win)
		local filetype = vim.api.nvim_get_option_value("filetype", { buf = buf })

		if filetype == "fugitive" then
			local win_tabpage = vim.api.nvim_win_get_tabpage(win)
			if win_tabpage == current_tabpage then
				vim.api.nvim_win_close(win, false)
			else
				vim.api.nvim_set_current_tabpage(win_tabpage)
			end
			return
		end
	end
	vim.cmd("tab Git")
end, { desc = "Toggle git status" })

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

vim.keymap.set("n", "<leader>gh", "<cmd>GBrowse<cr>", { desc = "Open in Github" })

vim.keymap.set("x", "<leader>gh", ":GBrowse<cr>", { desc = "Open in Github (selected lines)" })

vim.api.nvim_create_autocmd("FileType", {
	pattern = "fugitive",
	callback = function(event)
		vim.keymap.set("n", "<tab>", "]czt<c-y>", { buffer = event.buf, remap = true })
		vim.keymap.set("n", "<s-tab>", "[czt<c-y>", { buffer = event.buf, remap = true })
	end,
})
