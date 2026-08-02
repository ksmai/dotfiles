local MiniDiff = require("mini.diff")

MiniDiff.setup({
	source = MiniDiff.gen_source.none(),
	mappings = {
		apply = "",
		reset = "",
		textobject = "",
	},
})

vim.keymap.set("n", "<Plug>(mini-diff-yank)", function()
	return MiniDiff.operator("yank")
end, { expr = true })

vim.keymap.set("n", "<Plug>(mini-diff-reset)", function()
	return MiniDiff.operator("reset")
end, { expr = true })

vim.keymap.set("o", "<Plug>(mini-diff-hunk)", MiniDiff.textobject)

vim.keymap.set(
	"n",
	"<leader>dy",
	"<Plug>(mini-diff-yank)<Plug>(mini-diff-hunk)",
	{ remap = true, desc = "Yank current hunk's reference text", silent = true }
)

vim.keymap.set(
	"n",
	"<leader>dg",
	"<Plug>(mini-diff-reset)<Plug>(mini-diff-hunk)",
	{ remap = true, desc = "Reset current hunk", silent = true }
)

vim.api.nvim_create_user_command("DiffVSplit", function()
	local data = MiniDiff.get_buf_data()
	if data == nil or data.ref_text == nil then
		return
	end

	vim.cmd("diffoff!")

	local current_win = vim.api.nvim_get_current_win()

	local scratch_buf = vim.api.nvim_create_buf(false, true)

	local lines = vim.split(data.ref_text, "\n", { plain = true })
	vim.api.nvim_buf_set_lines(scratch_buf, 0, -1, false, lines)
	vim.bo[scratch_buf].filetype = vim.bo.filetype

	vim.cmd("aboveleft vsplit")
	local scratch_win = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(scratch_win, scratch_buf)

	vim.api.nvim_win_call(current_win, function()
		MiniDiff.disable()
		vim.cmd("diffthis")
	end)
	vim.api.nvim_win_call(scratch_win, function()
		vim.cmd("diffthis")
	end)
end, {
	desc = "Split unified diff",
})
