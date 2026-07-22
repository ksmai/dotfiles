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

local function adjust_brightness(color, factor)
	if color == nil then
		return nil
	end

	local r = math.floor(color / 65536) % 256
	local g = math.floor(color / 256) % 256
	local b = color % 256

	r = math.min(255, math.floor(r * factor))
	g = math.min(255, math.floor(g * factor))
	b = math.min(255, math.floor(b * factor))

	return r * 65536 + g * 256 + b
end

vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function()
		local del_hl = vim.api.nvim_get_hl(0, { name = "DiffDelete", link = false })
		local add_hl = vim.api.nvim_get_hl(0, { name = "DiffAdd", link = false })

		local brightness = 1 / 1.4
		vim.api.nvim_set_hl(0, "MiniDiffOverDelete", {
			bg = adjust_brightness(del_hl.bg, brightness),
		})
		vim.api.nvim_set_hl(0, "MiniDiffOverAdd", {
			bg = adjust_brightness(add_hl.bg, brightness),
		})

		vim.api.nvim_set_hl(0, "MiniDiffOverContext", {
			link = "MiniDiffOverDelete",
		})
		vim.api.nvim_set_hl(0, "MiniDiffOverContextBuf", {
			link = "MiniDiffOverAdd",
		})

		vim.api.nvim_set_hl(0, "MiniDiffOverChange", { link = "DiffDelete" })
		vim.api.nvim_set_hl(0, "MiniDiffOverChangeBuf", { link = "DiffAdd" })
	end,
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
