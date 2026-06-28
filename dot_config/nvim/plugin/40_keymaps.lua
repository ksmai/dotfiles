-- clipboard
vim.keymap.set({ "v", "n" }, "<leader>y", '"+y', { noremap = true, desc = "Yank into clipboard" })
vim.keymap.set({ "v", "n" }, "<leader>Y", '"+Y', { noremap = true, desc = "Yank into clipboard" })
vim.keymap.set({ "v", "n" }, "<leader>p", '"+p', { noremap = true, desc = "Put text from clipboard" })
vim.keymap.set({ "v", "n" }, "<leader>P", '"+P', { noremap = true, desc = "Put text from clipboard" })
vim.keymap.set({ "v", "n" }, "]p", "<esc><cmd>put<cr>", { noremap = true, desc = "Put linewise" })
vim.keymap.set({ "v", "n" }, "]P", "<esc><cmd>put<cr>", { noremap = true, desc = "Put linewise" })
vim.keymap.set(
	{ "v", "n" },
	"<leader>]p",
	"<esc><cmd>put +<cr>",
	{ noremap = true, desc = "Put linewise from clipboard" }
)
vim.keymap.set(
	{ "v", "n" },
	"<leader>]P",
	"<esc><cmd>put +<cr>",
	{ noremap = true, desc = "Put linewise from clipboard" }
)
vim.keymap.set({ "v", "n" }, "[p", "<cmd>put!<cr>", { noremap = true, desc = "Put linewise" })
vim.keymap.set({ "v", "n" }, "[P", "<cmd>put!<cr>", { noremap = true, desc = "Put linewise" })
vim.keymap.set({ "v", "n" }, "<leader>[p", "<cmd>put! +<cr>", { noremap = true, desc = "Put linewise from clipboard" })
vim.keymap.set({ "v", "n" }, "<leader>[P", "<cmd>put! +<cr>", { noremap = true, desc = "Put linewise from clipboard" })

-- quick save
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { silent = true, noremap = true, desc = "Save" })

vim.keymap.set("n", "<BS>", "<cmd>nohlsearch<cr>", { silent = true, noremap = true, desc = "Clear highlights" })

-- quick fix window
local function toggleQuickFix()
	if vim.fn.empty(vim.fn.filter(vim.fn.getwininfo(), "v:val.quickfix")) == 1 then
		vim.cmd("copen")
	else
		vim.cmd("cclose")
	end
end

vim.keymap.set("n", "<leader>q", toggleQuickFix, { noremap = true, silent = true, desc = "Toggle quickfix list" })

-- diffs
vim.keymap.set("n", "<leader>dw", "<cmd>windo diffthis<cr>", { silent = true, noremap = true, desc = "Diff windows" })
vim.keymap.set("n", "<leader>dq", "<cmd>diffoff!<cr>", { silent = true, noremap = true, desc = "Diff off" })

-- terminal
vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], { noremap = true, silent = true, desc = "Esc" })

-- tabs
vim.keymap.set("n", "<leader>1", "1gt", { noremap = true, silent = true, desc = "1st tab" })
vim.keymap.set("n", "<leader>2", "2gt", { noremap = true, silent = true, desc = "2nd tab" })
vim.keymap.set("n", "<leader>3", "3gt", { noremap = true, silent = true, desc = "3rd tab" })
vim.keymap.set("n", "<leader>4", "4gt", { noremap = true, silent = true, desc = "4th tab" })
vim.keymap.set("n", "<leader>5", "5gt", { noremap = true, silent = true, desc = "5th tab" })
vim.keymap.set("n", "<leader>6", "6gt", { noremap = true, silent = true, desc = "6th tab" })
vim.keymap.set("n", "<leader>7", "7gt", { noremap = true, silent = true, desc = "7th tab" })
vim.keymap.set("n", "<leader>8", "8gt", { noremap = true, silent = true, desc = "8th tab" })
vim.keymap.set("n", "<leader>9", "9gt", { noremap = true, silent = true, desc = "9th tab" })

local function move_current_buf(target_tabpage_number)
	local tabpages = vim.api.nvim_list_tabpages()
	local target_tabpage = nil
	for _, tabpage in ipairs(tabpages) do
		local tabpage_number = vim.api.nvim_tabpage_get_number(tabpage)
		if tabpage_number == target_tabpage_number then
			target_tabpage = tabpage
		end
	end

	if target_tabpage == nil then
		return
	end

	local current_tabpage = vim.api.nvim_get_current_tabpage()
	if target_tabpage == current_tabpage then
		return
	end

	local buf = vim.api.nvim_get_current_buf()
	local win = vim.api.nvim_get_current_win()
	vim.api.nvim_win_close(win, false)
	vim.api.nvim_set_current_tabpage(target_tabpage)
	vim.cmd("vsplit")
	vim.api.nvim_set_current_buf(buf)
end

vim.keymap.set("n", "<leader>!", function()
	move_current_buf(1)
end, { noremap = true, silent = true, desc = "move window to 1st tab" })
vim.keymap.set("n", "<leader>@", function()
	move_current_buf(2)
end, { noremap = true, silent = true, desc = "move window to 2nd tab" })
vim.keymap.set("n", "<leader>#", function()
	move_current_buf(3)
end, { noremap = true, silent = true, desc = "move window to 3rd tab" })

vim.keymap.set("n", "<leader>$", function()
	move_current_buf(4)
end, { noremap = true, silent = true, desc = "move window to 4th tab" })

vim.keymap.set("n", "<leader>%", function()
	move_current_buf(5)
end, { noremap = true, silent = true, desc = "move window to 5th tab" })

vim.keymap.set("n", "<leader>^", function()
	move_current_buf(6)
end, { noremap = true, silent = true, desc = "move window to 6th tab" })

vim.keymap.set("n", "<leader>&", function()
	move_current_buf(7)
end, { noremap = true, silent = true, desc = "move window to 7th tab" })

vim.keymap.set("n", "<leader>*", function()
	move_current_buf(8)
end, { noremap = true, silent = true, desc = "move window to 8th tab" })

vim.keymap.set("n", "<leader>(", function()
	move_current_buf(9)
end, { noremap = true, silent = true, desc = "move window to 9th tab" })

-- command mode
vim.keymap.set("c", "<C-a>", "<Home>")
vim.keymap.set("c", "<C-e>", "<End>")

-- handle frequent typos
vim.api.nvim_create_user_command("Q", "q", { bang = true })
vim.api.nvim_create_user_command("W", "w", { bang = true })
vim.api.nvim_create_user_command("Wq", "wq", { bang = true })
