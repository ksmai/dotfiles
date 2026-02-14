return {
	"mistweaverco/kulala.nvim",
	ft = { "http", "rest" },
	opts = {
		global_keymaps = {
			["Open scratchpad"] = {
				"<leader>ko",
				function()
					require("kulala").scratchpad()
				end,
			},

			["Copy as cURL"] = {
				"<leader>kc",
				function()
					require("kulala").copy()
				end,
				ft = { "http", "rest" },
			},

			["Paste from curl"] = {
				"<leader>kp",
				function()
					require("kulala").from_curl()
				end,
				ft = { "http", "rest" },
			},

			["Send request <cr>"] = {
				"<CR>",
				function()
					require("kulala").run()
				end,
				mode = { "n", "v" },
				ft = { "http", "rest" },
			},

			["Send all requests"] = {
				"<leader>ka",
				function()
					require("kulala").run_all()
				end,
				mode = { "n", "v" },
			},

			["Replay the last request"] = {
				"<leader>kl",
				function()
					require("kulala").replay()
				end,
			},

			["Find request"] = {
				"<leader>fk",
				function()
					require("kulala").search()
				end,
				ft = { "http", "rest" },
			},

			["Jump to next request"] = {
				"]k",
				function()
					require("kulala").jump_next()
				end,
				ft = { "http", "rest" },
			},

			["Jump to previous request"] = {
				"[k",
				function()
					require("kulala").jump_prev()
				end,
				ft = { "http", "rest" },
			},
		},

		kulala_keymaps = {
			["Next response"] = {
				"<tab>",
				function()
					require("kulala.ui").show_next()
				end,
			},
			["Previous response"] = {
				"<s-tab>",
				function()
					require("kulala.ui").show_previous()
				end,
			},
		},

		ui = {
			disable_news_popup = true,

			win_opts = {
				wo = { foldmethod = "manual" },
			},
		},

		generate_bug_report = false,

		-- change highlight timeout from the default 100ms to 500ms
		before_request = function(request)
			if request.start_line and request.end_line then
				local ns = vim.api.nvim_create_namespace("kulala_requests_flash")

				local start = { request.start_line, 0 }
				local finish = { request.end_line - 1, 0 }

				local opts = {
					regtype = "V",
					inclusive = false,
					timeout = 500,
				}

				vim.hl.range(0, ns, "IncSearch", start, finish, opts)
			end

			return true
		end,
	},

	init = function()
		vim.filetype.add({
			extension = {
				["http"] = "http",
			},
		})
	end,
}
