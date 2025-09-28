local sections = {
	lualine_b = {
		{
			"branch",
			fmt = function(s)
				if s:len() <= 17 then
					return s
				end

				return s:sub(1, 15) .. ".."
			end,
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
			timeout = 500,
		},
	},
}

local winbar = {
	lualine_c = { "aerial" },
	lualine_y = {
		{
			"lsp_status",
			draw_empty = true,
		},
	},
}

return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"stevearc/aerial.nvim",
	},
	opts = {
		options = {
			theme = "gruvbox",
			disabled_filetypes = {
				statusline = {},
				winbar = { "kulala_ui" },
			},
		},
		sections = sections,
		inactive_sections = sections,
		winbar = winbar,
		inactive_winbar = winbar,
	},
	init = function()
		-- remove default search count as it is already displayed in lualine
		vim.opt.shortmess:append("S")
	end,
}
