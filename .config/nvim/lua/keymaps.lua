-- clipboard
vim.keymap.set({ "v", "n" }, "<leader>y", "\"+y", { noremap = true, desc = "Yank into clipboard" })
vim.keymap.set({ "v", "n" }, "<leader>Y", "\"+Y", { noremap = true, desc = "Yank into clipboard" })
vim.keymap.set({ "v", "n" }, "<leader>p", "\"+p", { noremap = true, desc = "Put text from clipboard" })
vim.keymap.set({ "v", "n" }, "<leader>P", "\"+P", { noremap = true, desc = "Put text from clipboard" })

-- quick save
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { silent = true, noremap = true, desc = "Save" })

-- quick fix window
local function toggleQuickFix()
    if vim.fn.empty(vim.fn.filter(vim.fn.getwininfo(), 'v:val.quickfix')) == 1 then
        vim.cmd("copen")
    else
        vim.cmd("cclose")
    end
end

vim.keymap.set("n", "<leader>q", toggleQuickFix, { noremap = true, silent = true, desc = "Toggle quickfix list" })

-- handle frequent typos
vim.api.nvim_create_user_command("Q", "q", { bang = true })
vim.api.nvim_create_user_command("W", "w", { bang = true })
vim.api.nvim_create_user_command("Wq", "wq", { bang = true })
