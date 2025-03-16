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
		end,
	},
}
