local function augroup(name)
	return vim.api.nvim_create_augroup("ksmai_" .. name, { clear = true })
end

-- highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup("highlight_yank"),
	callback = function()
		vim.hl.on_yank({ higroup = "IncSearch", timeout = 500 })
	end,
})

-- resize splits if window got resized
-- vim.api.nvim_create_autocmd({"VimResized"}, {
--     group = augroup("resize_splits"),
--     callback = function() vim.cmd("tabdo wincmd =") end
-- })

-- spell checking in text filetypes
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("spell_checking"),
	pattern = { "gitcommit", "markdown", "text" },
	callback = function()
		vim.opt_local.spell = true
		vim.opt_local.spelllang = "en_us,cjk"
	end,
})

-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = "html",
-- 	command = "setlocal shiftwidth=2 tabstop=2 softtabstop=2",
-- })
