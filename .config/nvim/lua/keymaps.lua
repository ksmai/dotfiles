-- clipboard
vim.keymap.set({"v", "n"}, "<leader>y", '"+y',
               {noremap = true, desc = "Yank into clipboard"})
vim.keymap.set({"v", "n"}, "<leader>Y", '"+Y',
               {noremap = true, desc = "Yank into clipboard"})
vim.keymap.set({"v", "n"}, "<leader>p", '"+p',
               {noremap = true, desc = "Put text from clipboard"})
vim.keymap.set({"v", "n"}, "<leader>P", '"+P',
               {noremap = true, desc = "Put text from clipboard"})
vim.keymap.set({"v", "n"}, "<leader>]p", "<esc><cmd>put +<cr>",
               {noremap = true, desc = "Put linewise from clipboard"})
vim.keymap.set({"v", "n"}, "<leader>]P", "<esc><cmd>put +<cr>",
               {noremap = true, desc = "Put linewise from clipboard"})
vim.keymap.set({"v", "n"}, "<leader>[p", "<cmd>put! +<cr>",
               {noremap = true, desc = "Put linewise from clipboard"})
vim.keymap.set({"v", "n"}, "<leader>[P", "<cmd>put! +<cr>",
               {noremap = true, desc = "Put linewise from clipboard"})

-- quick save
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>",
               {silent = true, noremap = true, desc = "Save"})

-- quick fix window
local function toggleQuickFix()
    if vim.fn.empty(vim.fn.filter(vim.fn.getwininfo(), 'v:val.quickfix')) == 1 then
        vim.cmd("copen")
    else
        vim.cmd("cclose")
    end
end

vim.keymap.set("n", "<leader>q", toggleQuickFix,
               {noremap = true, silent = true, desc = "Toggle quickfix list"})

-- diffs
vim.keymap.set("n", "<leader>dw", "<cmd>windo diffthis<cr>",
               {silent = true, noremap = true, desc = "Diff windows"})
vim.keymap.set("n", "<leader>dq", "<cmd>diffoff!<cr>",
               {silent = true, noremap = true, desc = "Diff off"})

-- terminal
vim.keymap.set("t", "<esc>", [[<C-\><C-n>]],
               {noremap = true, silent = true, desc = "Esc"})

-- tabs
vim.keymap.set("n", "<leader>1", "1gt",
               {noremap = true, silent = true, desc = "1st tab"})
vim.keymap.set("n", "<leader>2", "2gt",
               {noremap = true, silent = true, desc = "2nd tab"})
vim.keymap.set("n", "<leader>3", "3gt",
               {noremap = true, silent = true, desc = "3rd tab"})
vim.keymap.set("n", "<leader>4", "4gt",
               {noremap = true, silent = true, desc = "4th tab"})
vim.keymap.set("n", "<leader>5", "5gt",
               {noremap = true, silent = true, desc = "5th tab"})
vim.keymap.set("n", "<leader>6", "6gt",
               {noremap = true, silent = true, desc = "6th tab"})
vim.keymap.set("n", "<leader>7", "7gt",
               {noremap = true, silent = true, desc = "7th tab"})
vim.keymap.set("n", "<leader>8", "8gt",
               {noremap = true, silent = true, desc = "8th tab"})
vim.keymap.set("n", "<leader>9", "9gt",
               {noremap = true, silent = true, desc = "9th tab"})

-- handle frequent typos
vim.api.nvim_create_user_command("Q", "q", {bang = true})
vim.api.nvim_create_user_command("W", "w", {bang = true})
vim.api.nvim_create_user_command("Wq", "wq", {bang = true})
