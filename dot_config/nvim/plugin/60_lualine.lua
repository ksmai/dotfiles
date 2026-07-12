local function location()
	local line = vim.fn.line(".")
	local total_lines = vim.fn.line("$")
	local col = vim.fn.charcol(".")
	return string.format("%3d/%d:%-2d", line, total_lines, col)
end

local function minidiff_hunk_count()
	local data = MiniDiff.get_buf_data()
	if data == nil or #data.hunks == 0 or vim.b.minidiff_summary == nil or vim.b.minidiff_summary.n_ranges == 0 then
		return ""
	end

	local last_range_to = -math.huge
	local cursor = vim.api.nvim_win_get_cursor(0)[1]
	local cur_range = 0

	for _, hunk in ipairs(data.hunks) do
		local range_from = math.max(hunk.buf_start, 1)
		local range_to = range_from + math.max(hunk.buf_count, 1) - 1

		if range_from > last_range_to + 1 then
			if cursor >= range_from then
				cur_range = cur_range + 1
			else
				break
			end
		end

		last_range_to = math.max(last_range_to, range_to)
	end

	return string.format("H:[%d/%d]", cur_range, vim.b.minidiff_summary.n_ranges)
end

local lualine_b = {
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
}

local lualine_c = {
	{
		"filename",
		file_status = true,
		newfile_status = true,
		path = 1,
	},
}

local encoding = {
	"encoding",
	show_bomb = true,
	fmt = function(s)
		if s ~= "utf-8" then
			return s
		end
	end,
}

local fileformat = {
	"fileformat",
	symbols = {
		unix = "",
		dos = "dos",
		mac = "mac",
	},
}

local lualine_x = {
	encoding,
	fileformat,
	{
		minidiff_hunk_count,
	},
}

local lualine_x_inactive = {
	encoding,
	fileformat,
}

local lualine_y = {
	{
		"searchcount",
		maxcount = 9999,
		fmt = function(s)
			if s == nil or s == "" then
				return s
			end
			return "S:" .. s
		end,
	},
}

local lualine_z = {
	location,
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
	sections = {
		lualine_b = lualine_b,
		lualine_c = lualine_c,
		lualine_x = lualine_x,
		lualine_y = lualine_y,
		lualine_z = lualine_z,
	},
	inactive_sections = {
		lualine_b = lualine_b,
		lualine_c = lualine_c,
		lualine_x = lualine_x_inactive,
		lualine_y = lualine_y,
		lualine_z = lualine_z,
	},
	winbar = winbar,
	inactive_winbar = winbar,
})
