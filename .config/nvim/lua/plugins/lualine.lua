local function lsp_client_names()
	local buf_client_names = {}
	for _, client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
		table.insert(buf_client_names, client.name)
	end
	return table.concat(buf_client_names, ", ")
end

local function lsp_status()
	if #vim.lsp.get_active_clients({ bufnr = 0 }) == 0 then
		return ""
	end

	local lsp = vim.lsp.util.get_progress_messages()[1]
	if lsp then
		local name = lsp.name or ""
		local msg = lsp.message or ""
		local percentage = lsp.percentage or 0
		local title = lsp.title or ""
		return string.format(" %%<%s: %s %s (%s%%%%) ", name, title, msg, percentage)
	end

	return lsp_client_names()
end

local function shortenedGitHead()
	return vim.fn.FugitiveHead():sub(1, 15)
end

return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons", "tpope/vim-fugitive" },
	opts = {
		options = { theme = "gruvbox" },
		sections = { lualine_b = { shortenedGitHead, "diff", "diagnostics" } },
		winbar = {
			lualine_c = { "navic", color_correction = nil, navic_opts = nil },
			lualine_y = { lsp_status },
		},
		inactive_winbar = {
			lualine_c = { "navic", color_correction = nil, navic_opts = nil },
			lualine_y = { lsp_status },
		},
	},
}
