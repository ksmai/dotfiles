return {
	{
		"L3MON4D3/LuaSnip",
		-- follow latest release.
		version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		-- install jsregexp (optional!).
		build = "make install_jsregexp",
		opts = { history = true, delete_check_events = "TextChanged" },
		config = function(_, opts)
			local ls = require("luasnip")
			ls.setup(opts)

			local snippets = require("snippets")
			for lang, snips in pairs(snippets) do
				ls.add_snippets(lang, snips)
			end

			-- https://github.com/L3MON4D3/LuaSnip/issues/258#issuecomment-1429989436
			vim.api.nvim_create_autocmd("ModeChanged", {
				pattern = "*",
				group = vim.api.nvim_create_augroup("UnlinkLuaSnip", { clear = true }),
				callback = function()
					if
						((vim.v.event.old_mode == "s" and vim.v.event.new_mode == "n") or vim.v.event.old_mode == "i")
						and require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
						and not require("luasnip").session.jump_active
					then
						require("luasnip").unlink_current()
					end
				end,
			})
		end,
	},
}
