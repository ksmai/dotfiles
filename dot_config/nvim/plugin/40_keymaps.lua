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

vim.keymap.set("n", "<Tab>", function()
	if vim.wo.diff then
		local current = vim.fn.line(".")
		vim.cmd("normal! ]c")

		if current ~= vim.fn.line(".") then
			return
		end
	end

	local ok = pcall(vim.cmd, "cnext")
	if ok then
		vim.schedule(function()
			if vim.wo.diff then
				local on_hunk = vim.fn.diff_hlID(".", 1) > 0
				if not on_hunk then
					vim.cmd("normal! ]c")
				end
			end
		end)
	end
end, { desc = "Next hunk/quickfix item" })

vim.keymap.set("n", "<S-Tab>", function()
	if vim.wo.diff then
		local current = vim.fn.line(".")
		vim.cmd("normal! [c")

		if current ~= vim.fn.line(".") then
			return
		end
	end

	local ok = pcall(vim.cmd, "cprev")

	if ok then
		vim.schedule(function()
			if vim.wo.diff then
				vim.cmd("normal! G")
				vim.cmd("normal! [c")
			end
		end)
	end
end, { desc = "Prev hunk/quickfix item" })

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
