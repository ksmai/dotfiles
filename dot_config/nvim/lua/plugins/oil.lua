return {
	"stevearc/oil.nvim",
	keys = {
		{
			"<leader>n",
			function()
				if vim.bo.filetype == "oil" then
					return
				end

				vim.cmd("Oil")
			end,
			mode = "n",
			noremap = true,
			silent = true,
			desc = "Open Oil",
		},
	},
	cmd = { "Oil" },
	opts = {
		default_file_explorer = true,
		view_options = { show_hidden = true },
		use_default_keymaps = false,
		keymaps = { ["<CR>"] = "actions.select" },
	},
	config = function(_, opts)
		require("oil").setup(opts)
		vim.cmd([[command! -nargs=1 Browse silent execute '!xdg-open' shellescape(<q-args>,1)]])
	end,
}
