require("fzf-lua").setup({
	"telescope",
	grep = {
		rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --hidden --iglob '!.git/*' -e",
	},
})

vim.cmd("FzfLua register_ui_select")

vim.keymap.set("n", "<C-p>", function()
	if vim.bo.filetype == "aerial-nav" then
		local key = vim.api.nvim_replace_termcodes("<C-p>", true, false, true)
		vim.api.nvim_feedkeys(key, "n", false)
	else
		require("fzf-lua-frecency").frecency({
			cwd_only = true,
			display_score = false,
			fzf_opts = {
				["--no-sort"] = false,
				["--tiebreak"] = "index",
			},
		})
	end
end, { desc = "Find files" })

vim.keymap.set("n", "<leader>fg", function()
	require("fzf-lua").live_grep({
		fzf_opts = {
			["--no-sort"] = true,
		},
	})
end, { desc = "Live grep" })

vim.keymap.set("n", "<leader>fw", function()
	require("fzf-lua").grep_cword({
		fzf_opts = {
			["--no-sort"] = true,
		},
	})
end, { desc = "Find word under cursor" })

vim.keymap.set("n", "<leader>fW", function()
	require("fzf-lua").grep_cWORD({
		fzf_opts = {
			["--no-sort"] = true,
		},
	})
end, { desc = "Find WORD under cursor" })

vim.keymap.set("x", "<leader>fw", function()
	require("fzf-lua").grep_visual({
		fzf_opts = {
			["--no-sort"] = true,
		},
	})
end, { desc = "Find selected word" })

vim.keymap.set("n", "<leader>fc", function()
	require("fzf-lua").commands()
end, { desc = "Find commands" })

vim.keymap.set("n", "<leader>fh", function()
	require("fzf-lua").help_tags()
end, { desc = "Find help tags" })

vim.keymap.set("n", "<leader>fl", function()
	require("fzf-lua").resume()
end, { desc = "Resume last picker" })

vim.keymap.set("n", "<leader>fz", function()
	require("fzf-lua").blines()
end, { desc = "Fuzzy search (current file)" })

vim.keymap.set("n", "<leader>fb", function()
	require("fzf-lua").buffers()
end, { desc = "Find buffers" })

vim.keymap.set("n", "<leader>fo", function()
	require("fzf-lua").oldfiles()
end, { desc = "Find oldfiles" })

vim.keymap.set("n", "<leader>fs", function()
	require("aerial").fzf_lua_picker({
		fzf_opts = {
			["--no-sort"] = true,
		},
	})
end, { desc = "Find symbols" })
