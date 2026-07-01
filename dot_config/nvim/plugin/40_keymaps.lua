for _, cmd in ipairs({ "y", "Y", "p", "P", "]p", "[p", "]P", "[P" }) do
	vim.keymap.set({ "x", "n" }, "<leader>" .. cmd, '"+' .. cmd, { remap = true, desc = "System clipboard" })
end

vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { silent = true, desc = "Quick save" })

vim.keymap.set("n", "<BS>", "<cmd>nohlsearch | mode<cr>", { silent = true, desc = "Clear highlights" })

vim.keymap.set("n", "<Tab>", "<cmd>cnext<cr>", { desc = "cnext" })
vim.keymap.set("n", "<S-Tab>", "<cmd>cprev<cr>", { desc = "cprev" })
vim.keymap.set("n", "<leader>q", function()
	if vim.fn.empty(vim.fn.filter(vim.fn.getwininfo(), "v:val.quickfix")) == 1 then
		vim.cmd("copen")
	else
		vim.cmd("cclose")
	end
end, { silent = true, desc = "Toggle quickfix list" })

vim.keymap.set("n", "<leader>dw", "<cmd>windo diffthis<cr>", { silent = true, desc = "Diff windows" })
vim.keymap.set("n", "<leader>dq", "<cmd>diffoff!<cr>", { silent = true, desc = "Diff off" })

vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], { silent = true, desc = "Esc" })

vim.keymap.set("c", "<C-a>", "<Home>")
vim.keymap.set("c", "<C-e>", "<End>")

vim.api.nvim_create_user_command("Q", "q", { bang = true })
vim.api.nvim_create_user_command("W", "w", { bang = true })
vim.api.nvim_create_user_command("Wq", "wq", { bang = true })
