return {
	{
		"zbirenbaum/copilot.lua",
		enabled = false,
		cmd = "Copilot",
		event = "InsertEnter",
		build = ":Copilot auth",
		opts = {
			suggestion = {
				auto_trigger = true,
				keymap = {
					accept = "<C-Right>",
					accept_word = false,
					accept_line = false,
					next = "<C-Down>",
					prev = "<C-Up>",
					dismiss = "<C-Left>",
				},
			},
		},
		config = function(_, opts)
			local copilot = require("copilot.suggestion")
			local luasnip = require("luasnip")

			require("copilot").setup(opts)

			local function set_trigger(trigger)
				vim.b.copilot_suggestion_auto_trigger = trigger
				vim.b.copilot_suggestion_hidden = not trigger
			end

			-- Hide suggestions when the completion menu is open.
			vim.api.nvim_create_autocmd("User", {
				pattern = "BlinkCmpMenuOpen",
				callback = function()
					if copilot.is_visible() then
						copilot.dismiss()
					end
					set_trigger(false)
				end,
			})

			vim.api.nvim_create_autocmd("User", {
				pattern = "BlinkCmpMenuClose",
				callback = function()
					set_trigger(not luasnip.expand_or_locally_jumpable())
				end,
			})

			-- Disable suggestions when inside a snippet.
			vim.api.nvim_create_autocmd("User", {
				pattern = { "LuasnipInsertNodeEnter", "LuasnipInsertNodeLeave" },
				callback = function()
					set_trigger(not luasnip.expand_or_locally_jumpable())
				end,
			})
		end,
	},
}
