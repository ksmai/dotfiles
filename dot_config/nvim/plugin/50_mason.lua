require("mason").setup()

require("mason-nvim-dap").setup({
	automatic_installation = false,
	handlers = {},
	ensure_installed = { "codelldb", "python", "coreclr" },
})
