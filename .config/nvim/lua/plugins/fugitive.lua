return {
	"tpope/vim-fugitive",

	dependencies = {
		{ "tpope/vim-rhubarb" },
	},

	cmd = {
		"G",
		"Git",
		"Gedit",
		"Gsplit",
		"Gdiffsplit",
		"Gvdiffsplit",
		"Gread",
		"Gwrite",
		"Ggrep",
		"GMove",
		"GRename",
		"GDelete",
		"GRemove",
		"GBrowse",
	},

	keys = {
		{
			"<leader>s",
			function()
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
			end,
			mode = "n",
			noremap = true,
			silent = true,
			desc = "Toggle git status",
		},
		{
			"<leader>gd",
			"<cmd>Gvdiffsplit !^<cr><C-w>R",
			mode = "n",
			noremap = true,
			silent = true,
			desc = "Git diff against parent",
		},
		{
			"<leader>gl",
			"<cmd>0Gclog<cr>",
			mode = "n",
			noremap = true,
			silent = true,
			desc = "Git log",
		},
		{
			"<leader>gl",
			":Gclog<cr>",
			mode = "v",
			noremap = true,
			silent = true,
			desc = "Git log (selected lines)",
		},
		{
			"<leader>gb",
			"<cmd>Git blame --date=relative<cr>",
			mode = "n",
			noremap = true,
			silent = true,
			desc = "Git blame",
		},
		{
			"<leader>gp",
			"<cmd>Git log --patch -- %<cr>",
			mode = "n",
			noremap = true,
			silent = true,
			desc = "Git log with patch",
		},
		{
			"<leader>gp",
			[[<esc><cmd>lua vim.cmd("Git log --patch -L" .. vim.api.nvim_buf_get_mark(0, "<")[1] .. "," .. vim.api.nvim_buf_get_mark(0, ">")[1] .. ":%")<cr>]],
			mode = "v",
			noremap = true,
			silent = true,
			desc = "Git log with patch",
		},
		{
			"<leader>gh",
			"<cmd>GBrowse<cr>",
			mode = "n",
			noremap = true,
			silent = true,
			desc = "Open in Github",
		},
		{
			"<leader>gh",
			":GBrowse<cr>",
			mode = "v",
			noremap = true,
			silent = true,
			desc = "Open in Github (selected lines)",
		},
	},

	init = function()
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "fugitive",
			callback = function(event)
				vim.keymap.set("n", "<tab>", "]czt<c-y>", { buffer = event.buf, remap = true })
				vim.keymap.set("n", "<s-tab>", "[czt<c-y>", { buffer = event.buf, remap = true })
			end,
		})
	end,
}
