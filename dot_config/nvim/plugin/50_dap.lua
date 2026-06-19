local dap = require("dap")
local dapui = require("dapui")

dapui.setup({})

require("nvim-dap-virtual-text").setup({
	display_callback = function(variable)
		local limit = 25
		if #variable.value > limit then
			return " " .. variable.value:sub(1, limit) .. "..."
		end
		return " " .. variable.value
	end,
})

vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
vim.fn.sign_define("DapBreakpoint", {
	text = " ",
	texthl = "DiagnosticInfo",
	linehl = "",
	numhl = "",
})
vim.fn.sign_define("DapBreakpointCondition", {
	text = " ",
	texthl = "DiagnosticInfo",
	linehl = "",
	numhl = "",
})
vim.fn.sign_define("DapBreakpointRejected", {
	text = " ",
	texthl = "DiagnosticError",
	linehl = "",
	numhl = "",
})
vim.fn.sign_define("DapStopped", {
	text = "󰁕 ",
	texthl = "DiagnosticWarn",
	linehl = "DapStoppedLine",
	numhl = "DapStoppedLine",
})
vim.fn.sign_define("DapLogPoint", {
	text = ".>",
	texthl = "DiagnosticInfo",
	linehl = "",
	numhl = "",
})

dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open({ reset = true })
end

dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close({})
end

dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close({})
end

vim.keymap.set("n", "<leader>du", function()
	require("dapui").toggle({ reset = true })
end, { desc = "Dap UI" })

vim.keymap.set({ "n", "x" }, "<C-\\>", function()
	require("dapui").eval()
end, { desc = "Eval" })

vim.keymap.set("n", "<leader>fd", "<cmd>FzfLua dap_commands<cr>", { desc = "Find DAP commands" })

vim.keymap.set("n", "<C-CR>", function()
	require("dap").toggle_breakpoint()
end, { desc = "DAP Toggle Breakpoint" })

vim.keymap.set("n", "<C-.>", function()
	require("dap").down()
end, { desc = "DAP Down" })

vim.keymap.set("n", "<C-,>", function()
	require("dap").up()
end, { desc = "DAP Up" })

vim.keymap.set("n", "<C-;>", function()
	require("dap").step_into()
end, { desc = "DAP Step Into" })

vim.keymap.set("n", "<C-S-;>", function()
	require("dap").step_out()
end, { desc = "DAP Step Out" })

vim.keymap.set("n", "<C-'>", function()
	require("dap").step_over()
end, { desc = "DAP Step Over" })

vim.keymap.set("n", "<C-S-'>", function()
	require("dap").run_to_cursor()
end, { desc = "DAP Run to Cursor" })

vim.keymap.set("n", "<C-/>", function()
	require("dap").continue()
end, { desc = "DAP Continue" })

vim.keymap.set("n", "<C-S-/>", function()
	require("dap").terminate()
end, { desc = "DAP Terminate" })
