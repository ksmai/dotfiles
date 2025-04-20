return {
	{
		"saghen/blink.cmp",
		dependencies = {
			"L3MON4D3/LuaSnip",
			"onsails/lspkind.nvim",
			"nvim-tree/nvim-web-devicons",
		},

		-- use a release tag to download pre-built binaries
		version = "*",

		opts = {
			keymap = {
				preset = "super-tab",

				["<Up>"] = {},
				["<Down>"] = {},
				["<C-space>"] = {},
				["<C-p>"] = { "show", "select_prev", "fallback_to_mappings" },
				["<C-n>"] = { "show", "select_next", "fallback_to_mappings" },

				-- hide completion when using copilot
				["<C-Up>"] = { "hide", "fallback" },
				["<C-Down>"] = { "hide", "fallback" },
				["<C-Left>"] = { "hide", "fallback" },
				["<C-Right>"] = { "hide", "fallback" },
			},

			appearance = {
				-- Sets the fallback highlight groups to nvim-cmp's highlight groups
				-- Useful for when your theme doesn't support blink.cmp
				-- Will be removed in a future release
				use_nvim_cmp_as_default = true,
				-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},

			-- Blink.cmp uses a Rust fuzzy matcher by default for typo resistance and significantly better performance
			-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
			-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
			--
			-- See the fuzzy documentation for more information
			fuzzy = { implementation = "prefer_rust_with_warning" },

			signature = {
				enabled = true,
				window = { border = "single" },
			},

			completion = {
				keyword = { range = "full" },

				accept = {
					auto_brackets = {
						enabled = false,
					},
				},

				menu = {
					border = "single",

					draw = {
						components = {
							kind_icon = {
								text = function(ctx)
									local icon = ctx.kind_icon
									if vim.tbl_contains({ "Path" }, ctx.source_name) then
										local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
										if dev_icon then
											icon = dev_icon
										end
									else
										icon = require("lspkind").symbolic(ctx.kind, {
											mode = "symbol",
										})
									end

									return icon .. ctx.icon_gap
								end,

								highlight = function(ctx)
									local hl = ctx.kind_hl
									if vim.tbl_contains({ "Path" }, ctx.source_name) then
										local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
										if dev_icon then
											hl = dev_hl
										end
									end
									return hl
								end,
							},

							kind = {
								highlight = function(ctx)
									local hl = ctx.kind_hl
									if vim.tbl_contains({ "Path" }, ctx.source_name) then
										local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
										if dev_icon then
											hl = dev_hl
										end
									end
									return hl
								end,
							},
						},
					},
				},

				-- Show documentation when selecting a completion item
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 100,
					window = { border = "single" },
				},

				-- Display a preview of the selected item on the current line
				ghost_text = { enabled = true },

				-- When false, will not show the completion window automatically when in a snippet
				trigger = { show_in_snippet = false },
			},

			snippets = { preset = "luasnip" },

			cmdline = {
				enabled = true,
				keymap = { preset = "inherit" },
				completion = {
					list = {
						selection = {
							auto_insert = true,
						},
					},
					menu = { auto_show = true },
					ghost_text = { enabled = true },
				},
			},
		},
		opts_extend = { "sources.default" },
	},
}
