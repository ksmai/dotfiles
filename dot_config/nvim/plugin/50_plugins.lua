vim.g.nremap = {
	-- disable maps in tpope/unimpaired in favor of treewalker.nvim
	["[e"] = "",
	["]e"] = "",
	-- conflict with jumps for neotest
	["[x"] = "",
	["[xx"] = "",
	["]x"] = "",
	["]xx"] = "",
}
vim.g.xremap = vim.g.nremap

vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind

		if kind == "install" or kind == "update" then
			if name == "mason.nvim" then
				if not ev.data.active then
					vim.cmd.packadd("mason.nvim")
				end
				vim.cmd("MasonUpdate")
			end

			if name == "nvim-treesitter" then
				if not ev.data.active then
					vim.cmd.packadd("nvim-treesitter")
				end
				vim.cmd("TSUpdate")
			end
		end
	end,
})

vim.pack.add({
	"https://github.com/aaronik/treewalker.nvim",
	"https://github.com/antoinemadec/FixCursorHold.nvim",
	"https://github.com/brenoprata10/nvim-highlight-colors",
	"https://github.com/elanmed/fzf-lua-frecency.nvim",
	"https://github.com/ellisonleao/gruvbox.nvim",
	"https://github.com/nvim-mini/mini.nvim",
	"https://github.com/ibhagwan/fzf-lua",
	{ src = "https://github.com/igorlfs/nvim-dap-view", version = vim.version.range("1.*") },
	"https://github.com/jay-babu/mason-nvim-dap.nvim",
	{
		src = "https://github.com/kylechui/nvim-surround",
		version = vim.version.range("4.x"),
	},
	"https://github.com/mfussenegger/nvim-dap",
	"https://github.com/mfussenegger/nvim-lint",
	{
		src = "https://github.com/mrcjkb/rustaceanvim",
		version = vim.version.range("^9"),
	},
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/nvim-neotest/neotest",
	"https://github.com/nvim-neotest/neotest-jest",
	"https://github.com/nvim-neotest/neotest-python",
	"https://github.com/nvim-neotest/nvim-nio",
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/onsails/lspkind.nvim",
	"https://github.com/OXY2DEV/markview.nvim",
	"https://github.com/stevearc/aerial.nvim",
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/tpope/vim-fugitive",
	"https://github.com/tpope/vim-rhubarb",
	"https://github.com/tpope/vim-sleuth",
	"https://github.com/tpope/vim-unimpaired",
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" },
	"https://github.com/williamboman/mason.nvim",
})

require("gruvbox").setup({ contrast = "hard" })
vim.cmd([[colorscheme gruvbox]])

require("aerial").setup({})

require("lspkind").setup({
	mode = "symbol_text",
	preset = "codicons",
})

require("nvim-surround").setup({
	aliases = {
		["k"] = "f",
	},
})

require("nvim-web-devicons").setup({})

require("mason").setup()
require("mason-nvim-dap").setup({
	automatic_installation = false,
	handlers = {},
	ensure_installed = { "codelldb", "python" },
})
