local function after_saved(fn)
	if not vim.bo.modified then
		fn()
		return
	end

	vim.cmd("write")

	vim.defer_fn(fn, 300)
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
				after_saved(function()
					require("neotest").run.run()
				end)
			end,
			mode = "n",
			noremap = true,
			silent = true,
			desc = "Run nearest test",
		},
		{
			"<leader>rd",
			function()
				after_saved(function()
					require("neotest").run.run({ strategy = "dap" })
				end)
			end,
			mode = "n",
			noremap = true,
			silent = true,
			desc = "Debug nearest test",
		},
		{
			"<leader>rl",
			function()
				after_saved(function()
					require("neotest").run.run_last()
				end)
			end,
			mode = "n",
			noremap = true,
			silent = true,
			desc = "Run last test",
		},
		{
			"<leader>rT",
			function()
				after_saved(function()
					require("neotest").run.stop()
				end)
			end,
			mode = "n",
			noremap = true,
			silent = true,
			desc = "Terminate",
		},
		{
			"<leader>rf",
			function()
				after_saved(function()
					require("neotest").run.run(vim.fn.expand("%"))
				end)
			end,
			mode = "n",
			noremap = true,
			silent = true,
			desc = "Run current file",
		},
		{
			"<leader>rw",
			function()
				after_saved(function()
					require("neotest").watch.toggle()
				end)
			end,
			mode = "n",
			noremap = true,
			silent = true,
			desc = "Toggle watch nearest test",
		},
		{
			"<leader>rW",
			function()
				after_saved(function()
					require("neotest").watch.toggle(vim.fn.expand("%"))
				end)
			end,
			mode = "n",
			noremap = true,
			silent = true,
			desc = "Toggle watch current file",
		},
		{
			"<leader>rq",
			function()
				after_saved(function()
					require("neotest").watch.stop()
				end)
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
			"[x",
			function()
				require("neotest").jump.prev({ status = "failed" })
			end,
			mode = "n",
			noremap = true,
			silent = true,
			desc = "Jump to previous test failure",
		},
		{
			"]x",
			function()
				require("neotest").jump.next({ status = "failed" })
			end,
			mode = "n",
			noremap = true,
			silent = true,
			desc = "Jump to next test failure",
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
			output = {
				open_on_run = false,
			},
			output_panel = {
				enabled = false,
			},
		}
	end,
}
