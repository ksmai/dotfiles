require("oil").setup({
	default_file_explorer = true,
	view_options = { show_hidden = true },
	use_default_keymaps = false,
	keymaps = {
		["<CR>"] = "actions.select",
		["<F4>"] = "actions.preview",
	},
})

vim.keymap.set("n", "<leader>n", function()
	if vim.bo.filetype == "oil" then
		return
	end

	vim.cmd("Oil")
end, { desc = "Open Oil" })
