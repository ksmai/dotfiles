-- Disable entire built-in ftplugin mappings to avoid conflicts.
-- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
vim.g.no_plugin_maps = true

vim.hl.priorities.semantic_tokens = 95

local nvim_treesitter = require("nvim-treesitter")

require("nvim-treesitter-textobjects").setup({
	move = {
		set_jumps = true,
	},
})

vim.keymap.set({ "n", "x", "o" }, "]]", function()
	require("nvim-treesitter-textobjects.move").goto_next_start({ "@class.outer", "@function.outer" }, "textobjects")
end, { desc = "Goto next start" })

vim.keymap.set({ "n", "x", "o" }, "][", function()
	require("nvim-treesitter-textobjects.move").goto_next_end({ "@class.outer", "@function.outer" }, "textobjects")
end, { desc = "Goto next end" })

vim.keymap.set({ "n", "x", "o" }, "[[", function()
	require("nvim-treesitter-textobjects.move").goto_previous_start(
		{ "@class.outer", "@function.outer" },
		"textobjects"
	)
end, { desc = "Goto previous start" })

vim.keymap.set({ "n", "x", "o" }, "[]", function()
	require("nvim-treesitter-textobjects.move").goto_previous_end({ "@class.outer", "@function.outer" }, "textobjects")
end, { desc = "Goto previous end" })

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("SetupTreesitter", { clear = true }),

	callback = function(args)
		local lang = vim.treesitter.language.get_lang(args.match) or args.match
		local buf = args.buf

		-- disable in minified files
		local line_count = vim.api.nvim_buf_line_count(buf)
		local file_size = vim.api.nvim_buf_get_offset(buf, line_count)
		if file_size / line_count > 10000 then
			vim.notify("[treesitter] ignoring minified file", vim.log.levels.WARN)
			return
		end

		if vim.tbl_contains(nvim_treesitter.get_installed(), lang) then
		elseif vim.tbl_contains(nvim_treesitter.get_available(), lang) then
			local choice = vim.fn.confirm("Install treesitter parser for " .. lang .. " ?", "&Yes\n&No", 1)
			if choice == 1 then
				nvim_treesitter.install({ lang })
			end
		else
		end

		if vim.treesitter.query.get(lang, "highlights") then
			vim.treesitter.start(buf, lang)
		end

		if vim.treesitter.query.get(lang, "folds") then
			vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
			vim.wo[0][0].foldmethod = "expr"
			vim.wo[0][0].foldlevel = 99
		end

		if vim.treesitter.query.get(lang, "indents") then
			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end
	end,
})
