local function location()
	local line = vim.fn.line(".")
	local total_lines = vim.fn.line("$")
	local col = vim.fn.charcol(".")
	return string.format("%3d/%d:%-2d", line, total_lines, col)
end

local sections = {
	lualine_b = {
		{
			"FugitiveHead",
			fmt = function(s)
				if s:len() <= 17 then
					return s
				end

				return s:sub(1, 16) .. "…"
			end,
			icon = "",
		},
	},
	lualine_c = {
		{
			"filename",
			file_status = true,
			newfile_status = true,
			path = 1,
		},
	},
	lualine_x = {
		{
			"encoding",
			show_bomb = true,
			fmt = function(s)
				if s ~= "utf-8" then
					return s
				end
			end,
		},
		{
			"fileformat",
			symbols = {
				unix = "",
				dos = "dos",
				mac = "mac",
			},
		},
	},
	lualine_y = {
		{
			"searchcount",
			maxcount = 9999,
		},
	},
	lualine_z = {
		location,
	},
}

local winbar = {
	lualine_c = { { "aerial", draw_empty = true } },
	lualine_y = {
		"lsp_status",
	},
}

-- remove default search count as it is already displayed in lualine
vim.opt.shortmess:append("S")

require("lualine").setup({
	options = {
		theme = "gruvbox",
		disabled_filetypes = {
			statusline = {},
			winbar = { "kulala_ui", "dap-view", "dap-repl" },
		},
	},
	sections = sections,
	inactive_sections = sections,
	winbar = winbar,
	inactive_winbar = winbar,
})
