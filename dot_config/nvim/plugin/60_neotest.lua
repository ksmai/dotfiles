require("neotest").setup({
	adapters = {
		require("neotest-python")({
			args = { "--log-level", "WARNING" },
			dap = { justMyCode = true },
		}),
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
})

vim.keymap.set("n", "<leader>rt", function()
	require("neotest").run.run()
end, { desc = "Run nearest test" })

vim.keymap.set("n", "<leader>rd", function()
	require("neotest").run.run({ strategy = "dap" })
end, { desc = "Debug nearest test" })

vim.keymap.set("n", "<leader>rl", function()
	require("neotest").run.run_last()
end, { desc = "Run last test" })

vim.keymap.set("n", "<leader>rT", function()
	require("neotest").run.stop()
end, { desc = "Terminate" })

vim.keymap.set("n", "<leader>rf", function()
	require("neotest").run.run(vim.fn.expand("%"))
end, { desc = "Run current file" })

vim.keymap.set("n", "<leader>rw", function()
	require("neotest").watch.toggle(vim.fn.expand("%"))
end, { desc = "Toggle watch current file" })

vim.keymap.set("n", "<leader>ro", function()
	require("neotest").output.open({ enter = true })
end, { desc = "Open test result" })

vim.keymap.set("n", "<leader>rO", function()
	require("neotest").output_panel.toggle()
end, { desc = "Toggle output panel" })

vim.keymap.set("n", "<leader>rs", function()
	require("neotest").summary.toggle()
end, { desc = "Toggle summary window" })

vim.keymap.set("n", "[x", function()
	require("neotest").jump.prev({ status = "failed" })
end, { desc = "Jump to previous test failure" })

vim.keymap.set("n", "]x", function()
	require("neotest").jump.next({ status = "failed" })
end, { desc = "Jump to next test failure" })

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("NeotestOutput", { clear = true }),
	pattern = "neotest-output",
	callback = function(ev)
		vim.keymap.set("n", "q", "<C-w>c", {
			buf = ev.buf,
		})
	end,
})
