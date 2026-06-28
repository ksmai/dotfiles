vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("HighlightOnYank", { clear = true }),
	callback = function()
		vim.hl.on_yank({ higroup = "IncSearch", timeout = 500 })
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("SpellChecking", { clear = true }),
	pattern = { "gitcommit", "markdown", "text" },
	callback = function()
		vim.opt_local.spell = true
		vim.opt_local.spelllang = "en_us,cjk"
	end,
})

vim.api.nvim_create_autocmd({ "VimEnter", "VimResume", "UIEnter" }, {
	group = vim.api.nvim_create_augroup("KittySetVarInEditor", { clear = true }),
	callback = function()
		vim.api.nvim_ui_send("\x1b]1337;SetUserVar=in_editor=MQ==\007")
	end,
})

vim.api.nvim_create_autocmd({ "VimLeave", "VimSuspend" }, {
	group = vim.api.nvim_create_augroup("KittyUnsetVarInEditor", { clear = true }),
	callback = function()
		vim.api.nvim_ui_send("\x1b]1337;SetUserVar=in_editor\007")
	end,
})
