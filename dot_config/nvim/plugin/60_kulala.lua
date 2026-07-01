vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("LazyLoadKulala", { clear = true }),
	once = true,
	pattern = "http",
	callback = function()
		vim.pack.add({ "https://github.com/mistweaverco/kulala.nvim" })

		require("kulala").setup({
			global_keymaps = {
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
				["Show verbose"] = {
					"D",
					function()
						require("kulala.ui").show_verbose()
					end,
				},
			},

			ui = {
				disable_news_popup = true,

				win_opts = {
					wo = { foldmethod = "manual" },
				},
			},

			max_response_size = 1024 * 1024,
			max_request_size = 16384,
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
		})
	end,
})
