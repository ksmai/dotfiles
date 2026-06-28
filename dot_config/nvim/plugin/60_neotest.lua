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

local function after_saved(fn)
	if not vim.bo.modified then
		fn()
		return
	end

	vim.cmd("write")

	vim.defer_fn(fn, 300)
end

vim.keymap.set("n", "<leader>rt", function()
	after_saved(function()
		require("neotest").run.run()
	end)
end, { desc = "Run nearest test" })

vim.keymap.set("n", "<leader>rd", function()
	after_saved(function()
		require("neotest").run.run({ strategy = "dap" })
	end)
end, { desc = "Debug nearest test" })

vim.keymap.set("n", "<leader>rl", function()
	after_saved(function()
		require("neotest").run.run_last()
	end)
end, { desc = "Run last test" })

vim.keymap.set("n", "<leader>rT", function()
	after_saved(function()
		require("neotest").run.stop()
	end)
end, { desc = "Terminate" })

vim.keymap.set("n", "<leader>rf", function()
	after_saved(function()
		require("neotest").run.run(vim.fn.expand("%"))
	end)
end, { desc = "Run current file" })

vim.keymap.set("n", "<leader>rw", function()
	after_saved(function()
		require("neotest").watch.toggle(vim.fn.expand("%"))
	end)
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
