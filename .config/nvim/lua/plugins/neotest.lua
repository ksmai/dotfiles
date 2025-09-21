local function ensure_saved()
	if not vim.bo.modified then
		return
	end

	require("conform").format({ async = false, lsp_format = "fallback", range = nil })

	vim.cmd("noautocmd write")
end

return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		{ "antoinemadec/FixCursorHold.nvim" },
		"mfussenegger/nvim-dap",
		"nvim-neotest/neotest-python",
		"nvim-neotest/neotest-jest",
		"mrcjkb/rustaceanvim",
	},
	keys = {
		{
			"<leader>rt",
			function()
				ensure_saved()
				require("neotest").run.run()
			end,
			mode = "n",
			noremap = true,
			silent = true,
			desc = "Run nearest test",
		},
		{
			"<leader>rd",
			function()
				ensure_saved()
				require("neotest").run.run({ strategy = "dap" })
			end,
			mode = "n",
			noremap = true,
			silent = true,
			desc = "Debug nearest test",
		},
		{
			"<leader>rl",
			function()
				ensure_saved()
				require("neotest").run.run_last()
			end,
			mode = "n",
			noremap = true,
			silent = true,
			desc = "Run last test",
		},
		{
			"<leader>rT",
			function()
				ensure_saved()
				require("neotest").run.stop()
			end,
			mode = "n",
			noremap = true,
			silent = true,
			desc = "Terminate",
		},
		{
			"<leader>rf",
			function()
				ensure_saved()
				require("neotest").run.run(vim.fn.expand("%"))
			end,
			mode = "n",
			noremap = true,
			silent = true,
			desc = "Run current file",
		},
		{
			"<leader>rw",
			function()
				ensure_saved()
				require("neotest").watch.toggle()
			end,
			mode = "n",
			noremap = true,
			silent = true,
			desc = "Toggle watch nearest test",
		},
		{
			"<leader>rW",
			function()
				ensure_saved()
				require("neotest").watch.toggle(vim.fn.expand("%"))
			end,
			mode = "n",
			noremap = true,
			silent = true,
			desc = "Toggle watch current file",
		},
		{
			"<leader>rq",
			function()
				ensure_saved()
				require("neotest").watch.stop()
			end,
			mode = "n",
			noremap = true,
			silent = true,
			desc = "Stop watching",
		},
		{
			"<leader>ro",
			function()
				require("neotest").output.open({ enter = true })
			end,

			mode = "n",
			noremap = true,
			silent = true,
			desc = "Open test result",
		},
		{
			"<leader>rO",
			function()
				require("neotest").output_panel.toggle()
			end,
			mode = "n",
			noremap = true,
			silent = true,
			desc = "Toggle output panel",
		},
		{
			"<leader>rs",
			function()
				require("neotest").summary.toggle()
			end,
			mode = "n",
			noremap = true,
			silent = true,
			desc = "Toggle summary window",
		},
		{
			"[t",
			function()
				require("neotest").jump.prev({ status = "failed" })
			end,
			mode = "n",
			noremap = true,
			silent = true,
			desc = "Jump to previous failed test",
		},
		{
			"]t",
			function()
				require("neotest").jump.next({ status = "failed" })
			end,
			mode = "n",
			noremap = true,
			silent = true,
			desc = "Jump to next failed test",
		},
	},
	opts = function()
		return {
			adapters = {
				require("neotest-python"),
				require("neotest-jest")({}),
				require("rustaceanvim.neotest"),
			},
			discovery = {
				-- Drastically improve performance in ginormous projects by
				-- only AST-parsing the currently opened buffer.
				enabled = false,
				-- Number of workers to parse files concurrently.
				-- A value of 0 automatically assigns number based on CPU.
				-- Set to 1 if experiencing lag.
				concurrent = 1,
			},
			quickfix = { enabled = false },
			running = {
				-- Run tests concurrently when an adapter provides multiple commands to run.
				concurrent = true,
			},
		}
	end,
}
