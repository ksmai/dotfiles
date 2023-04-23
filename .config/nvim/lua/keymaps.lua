-- clipboard
vim.keymap.set({ "v", "n" }, "<leader>y", "\"+y", { noremap = true, desc = "Yank into clipboard" })
vim.keymap.set({ "v", "n" }, "<leader>Y", "\"+Y", { noremap = true, desc = "Yank into clipboard" })
vim.keymap.set({ "v", "n" }, "<leader>p", "\"+p", { noremap = true, desc = "Put text from clipboard" })
vim.keymap.set({ "v", "n" }, "<leader>P", "\"+P", { noremap = true, desc = "Put text from clipboard" })

-- quick save
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { silent = true, noremap = true, desc = "Save" })
