local dap = require("dap")
local dap_view = require("dap-view")

dap.defaults.fallback.stepping_granularity = "line"
dap.defaults.fallback.switchbuf = "usetab,uselast"

dap_view.setup({
	winbar = {
		sections = { "watches", "exceptions", "breakpoints", "scopes", "threads", "repl", "console" },
		default_section = "scopes",
	},
	virtual_text = {
		enabled = true,
		format = function(variable, _, _)
			local limit = 25
			if #variable.value > limit then
				return " " .. variable.value:sub(1, limit) .. "…"
			end
			return " " .. variable.value
		end,
	},
	auto_toggle = true,
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


vim.keymap.set({ "n", "x" }, "<C-\\>", function()
	dap_view.hover()
end, { desc = "DAP Hover" })

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
