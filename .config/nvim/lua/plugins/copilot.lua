return {
	{
		"zbirenbaum/copilot.lua",
		enabled = false,
		cmd = "Copilot",
		event = "InsertEnter",
		opts = {
			suggestion = { enabled = false },
			panel = { enabled = false },
			filetypes = {
				markdown = true,
				help = true,
			},
		},

		config = function(_, opts)
			require("copilot").setup(opts)
			vim.cmd("Copilot disable")
		end,
	},
}
