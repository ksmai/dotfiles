local mini_ai = require("mini.ai")
local jump2d = require("mini.jump2d")
local operators = require("mini.operators")
local splitjoin = require("mini.splitjoin")
local pairs = require("mini.pairs")
local diff = require("mini.diff")

mini_ai.setup({
	n_lines = 9999,
	search_method = "cover_or_next",
	silent = true,

	custom_textobjects = {
		b = { { "%b()", "%b[]", "%b{}" }, "^.%s*().-()%s*.$" },
		k = mini_ai.gen_spec.function_call(),
		f = mini_ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
		c = mini_ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
	},
})

-- The default cover_or_next might prefer a next match on the current line
-- over a covering match that is not on the current line. We split the search
-- into 2 find_textobject calls to avoid this issue. Note that silent has to
-- be true in order to avoid some inaccurate error messages.
local find_textobject = mini_ai.find_textobject
mini_ai.find_textobject = function(ai_type, id, opts)
	if opts.n_times ~= 1 or opts.search_method ~= "cover_or_next" then
		return find_textobject(ai_type, id, opts)
	end

	return find_textobject(ai_type, id, vim.tbl_deep_extend("force", opts, { search_method = "cover" }))
		or find_textobject(ai_type, id, vim.tbl_deep_extend("force", opts, { search_method = "next" }))
end

splitjoin.setup({
	mappings = {
		toggle = "<leader>cj",
	},
})

operators.setup({})
pairs.setup({
	mappings = {
		["("] = { neigh_pattern = "^[^\\][%s%])}]$" },
		["["] = { neigh_pattern = "^[^\\][%s%])}]$" },
		["{"] = { neigh_pattern = "^[^\\][%s%])}]$" },
	},
})

diff.setup({
	source = diff.gen_source.none(),
	mappings = {
		apply = "",
		reset = "",
		textobject = "",
	},
})

vim.keymap.set("n", "<Plug>(mini-diff-yank)", function()
	return diff.operator("yank")
end, { expr = true })
vim.keymap.set("n", "<Plug>(mini-diff-reset)", function()
	return diff.operator("reset")
end, { expr = true })
vim.keymap.set("o", "<Plug>(mini-diff-hunk)", diff.textobject)

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

jump2d.setup({
	mappings = {
		start_jumping = "",
	},
})

vim.keymap.set("n", "\\", function()
	local opts = {
		spotter = function()
			return {}
		end,
		allowed_lines = { blank = false, fold = false },
		view = {
			dim = true,
			n_steps_ahead = 10,
		},
	}

	local before_start = function()
		local _, char = pcall(vim.fn.getcharstr)
		if char == nil then
			return
		end

		char = vim.fn.escape(char, "\\")

		if string.match(char, "%l") then
			local upper = string.upper(char)
			char = "\\[" .. char .. upper .. "]"
		end

		opts.spotter = jump2d.gen_spotter.vimpattern([[\V\C]] .. char)
	end
	opts.hooks = { before_start = before_start }

	require("mini.jump2d").start(opts)
end, { desc = "Jump 2D" })
