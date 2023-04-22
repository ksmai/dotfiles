-- clipboard
vim.keymap.set({"v", "n"}, "<leader>y", "\"+y", { noremap = true })
vim.keymap.set({"v", "n"}, "<leader>Y", "\"+Y", { noremap = true })
vim.keymap.set({"v", "n"}, "<leader>p", "\"+p", { noremap = true })
vim.keymap.set({"v", "n"}, "<leader>P", "\"+P", { noremap = true })

-- quick save
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { noremap = true })
