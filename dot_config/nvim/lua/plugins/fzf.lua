return {
	"ibhagwan/fzf-lua",
	dependencies = {
		{ "junegunn/fzf", build = "./install --bin" },
		{ "elanmed/fzf-lua-frecency.nvim" },
	},
	cmd = { "FzfLua" },
	keys = {
		{
			"<C-p>",
			function()
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
			end,
			mode = "n",
			noremap = true,
			silent = true,
			desc = "Find files",
		},
		{
			"<leader>fg",
			function()
				require("fzf-lua").live_grep({
					fzf_opts = {
						["--no-sort"] = true,
					},
				})
			end,
			mode = "n",
			noremap = true,
			silent = true,
			desc = "Live grep",
		},
		{
			"<leader>fw",
			function()
				require("fzf-lua").grep_cword({
					fzf_opts = {
						["--no-sort"] = true,
					},
				})
			end,
			mode = "n",
			noremap = true,
			silent = true,
			desc = "Find word under cursor",
		},
		{
			"<leader>fW",
			function()
				require("fzf-lua").grep_cWORD({
					fzf_opts = {
						["--no-sort"] = true,
					},
				})
			end,
			mode = "n",
			noremap = true,
			silent = true,
			desc = "Find WORD under cursor",
		},
		{
			"<leader>fw",
			function()
				require("fzf-lua").grep_visual({
					fzf_opts = {
						["--no-sort"] = true,
					},
				})
			end,
			mode = "v",
			noremap = true,
			silent = true,
			desc = "Find selected word",
		},
		{
			"<leader>fc",
			function()
				require("fzf-lua").commands()
			end,
			mode = "n",
			noremap = true,
			silent = true,
			desc = "Find commands",
		},
		{
			"<leader>fh",
			function()
				require("fzf-lua").help_tags()
			end,
			mode = "n",
			noremap = true,
			silent = true,
			desc = "Find help tags",
		},
		{
			"<leader>fl",
			function()
				require("fzf-lua").resume()
			end,
			mode = "n",
			noremap = true,
			silent = true,
			desc = "Resume last picker",
		},
		{
			"<leader>fz",
			function()
				require("fzf-lua").blines()
			end,
			mode = "n",
			noremap = true,
			silent = true,
			desc = "Fuzzy search (current file)",
		},
		{
			"<leader>fb",
			function()
				require("fzf-lua").buffers()
			end,
			mode = "n",
			noremap = true,
			silent = true,
			desc = "Find buffers",
		},
		{
			"<leader>fo",
			function()
				require("fzf-lua").oldfiles()
			end,
			mode = "n",
			noremap = true,
			silent = true,
			desc = "Find oldfiles",
		},
		{
			"<leader>fs",
			function()
				require("aerial").fzf_lua_picker({
					fzf_opts = {
						["--no-sort"] = true,
					},
				})
			end,
			mode = "n",
			noremap = true,
			silent = true,
			desc = "Find symbols",
		},
	},
	config = function()
		require("fzf-lua").setup({ "telescope" })
		vim.cmd("FzfLua register_ui_select")
	end,
}
