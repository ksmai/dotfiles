require("blink.cmp").setup({
	keymap = {
		preset = "super-tab",
		["<Up>"] = {},
		["<Down>"] = {},
		["<C-space>"] = {},
		["<C-p>"] = { "show", "select_prev", "fallback_to_mappings" },
		["<C-n>"] = { "show", "select_next", "fallback_to_mappings" },
	},

	signature = {
		enabled = true,
		window = { border = "single" },
	},

	completion = {
		accept = {
			auto_brackets = {
				enabled = false,
			},
		},

		menu = {
			border = "single",

			draw = {
				columns = {
					{ "kind_icon" },
					{ "label", "label_description", gap = 1 },
					{ "kind" },
				},

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

								-- if LSP source, check for color derived from documentation
								if vim.tbl_contains({ "LSP" }, ctx.source_name) then
									local color_item = require("nvim-highlight-colors").format(
										ctx.item.documentation,
										{ kind = ctx.kind }
									)
									if color_item and color_item.abbr ~= "" then
										icon = color_item.abbr
									end
								end
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
							elseif vim.tbl_contains({ "LSP" }, ctx.source_name) then
								local color_item =
									require("nvim-highlight-colors").format(ctx.item.documentation, { kind = ctx.kind })
								if color_item and color_item.abbr_hl_group then
									hl = color_item.abbr_hl_group
								end
							end

							return hl
						end,
					},

					kind = {
						text = function(ctx)
							return "[" .. ctx.kind .. "]"
						end,

						highlight = function(ctx)
							local hl = ctx.kind_hl

							if vim.tbl_contains({ "Path" }, ctx.source_name) then
								local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
								if dev_icon then
									hl = dev_hl
								end
							elseif vim.tbl_contains({ "LSP" }, ctx.source_name) then
								local color_item =
									require("nvim-highlight-colors").format(ctx.item.documentation, { kind = ctx.kind })
								if color_item and color_item.abbr_hl_group then
									hl = color_item.abbr_hl_group
								end
							end

							return hl
						end,
					},
				},
			},
		},

		documentation = {
			auto_show = true,
			auto_show_delay_ms = 100,
			window = { border = "single" },
		},

		ghost_text = { enabled = true },
	},

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
})
