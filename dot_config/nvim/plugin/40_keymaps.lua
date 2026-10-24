for _, cmd in ipairs({ "y", "Y", "p", "P", "]p", "[p", "]P", "[P" }) do
	vim.keymap.set({ "x", "n" }, "<leader>" .. cmd, '"+' .. cmd, { remap = true, desc = "System clipboard" })
end

vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { silent = true, desc = "Quick save" })

vim.keymap.set(
	"n",
	"<BS>",
	"<cmd>nohlsearch | mode | lua require('lualine').refresh()<cr>",
	{ silent = true, desc = "Refresh" }
)

vim.keymap.set("n", "<leader>dw", "<cmd>diffoff! | windo diffthis<cr>", { silent = true, desc = "Diff windows" })

vim.keymap.set("n", "<leader>dq", function()
	vim.cmd("diffoff!")
	require("mini.diff").disable()
end, { silent = true, desc = "Diff off" })

vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { silent = true, desc = "Esc" })

vim.keymap.set("c", "<C-a>", "<Home>")
vim.keymap.set("c", "<C-e>", "<End>")

vim.api.nvim_create_user_command("ScratchBuf", function()
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_win_set_buf(0, buf)
end, { desc = "Open a Scratch buffer" })

vim.api.nvim_create_user_command("Q", "q", { bang = true })
vim.api.nvim_create_user_command("W", "w", { bang = true })
vim.api.nvim_create_user_command("Wq", "wq", { bang = true })
