return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	branch = "main",

	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
	},

	config = function()
		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("SetupTreesitter", { clear = true }),

			pattern = {
				"bash",
				"css",
				"diff",
				"dockerfile",
				"fish",
				"gitconfig",
				"gitrebase",
				"gitattributes",
				"gitcommit",
				"gitignore",
				"glsl",
				"go",
				"html",
				"http",
				"javascript",
				"javascriptreact",
				"json",
				"lua",
				"make",
				"markdown",
				"mermaid",
				"python",
				"qml",
				"rust",
				"scss",
				"sql",
				"svelte",
				"typescript",
				"typescriptreact",
				"vue",
				"yaml",
			},

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

				require("nvim-treesitter").install({ lang })

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

		vim.hl.priorities.semantic_tokens = 95
	end,
}
