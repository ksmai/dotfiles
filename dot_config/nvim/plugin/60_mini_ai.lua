local MiniAi = require("mini.ai")

MiniAi.setup({
	n_lines = 9999,
	search_method = "cover_or_next",
	silent = true,

	custom_textobjects = {
		b = { { "%b()", "%b[]", "%b{}" }, "^.%s*().-()%s*.$" },
		k = MiniAi.gen_spec.function_call(),
		f = MiniAi.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
		c = MiniAi.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
		i = MiniAi.gen_spec.treesitter({ a = "@conditional.outer", i = "@conditional.inner" }),
		o = MiniAi.gen_spec.treesitter({ a = "@loop.outer", i = "@loop.inner" }),
		t = false,
	},
})

-- The default cover_or_next might prefer a next match on the current line
-- over a covering match that is not on the current line. We split the search
-- into 2 find_textobject calls to avoid this issue. Note that silent has to
-- be true in order to avoid some inaccurate error messages.
local find_textobject = MiniAi.find_textobject
MiniAi.find_textobject = function(ai_type, id, opts)
	if opts.n_times ~= 1 or opts.search_method ~= "cover_or_next" then
		return find_textobject(ai_type, id, opts)
	end

	return find_textobject(ai_type, id, vim.tbl_deep_extend("force", opts, { search_method = "cover" }))
		or find_textobject(ai_type, id, vim.tbl_deep_extend("force", opts, { search_method = "next" }))
end
