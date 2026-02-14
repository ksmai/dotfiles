return {
	"lewis6991/gitsigns.nvim",

	event = { "BufReadPost" },

	keys = {
		{
			"<leader>gB",
			"<cmd>Gitsigns toggle_current_line_blame<cr>",
			mode = "n",
			silent = true,
			noremap = true,
			desc = "Toggle virtual git blame",
		},
	},

	opts = {
		signcolumn = false,

		current_line_blame_opts = {
			delay = 100,
		},

		on_attach = function(bufnr)
			local gitsigns = require("gitsigns")

			local function map(mode, l, r, opts)
				opts = opts or {}
				opts.buffer = bufnr
				vim.keymap.set(mode, l, r, opts)
			end

			map("n", "]c", function()
				if vim.wo.diff then
					vim.cmd.normal({ "]c", bang = true })
				else
					gitsigns.nav_hunk("next")
				end
			end, { desc = "Next hunk" })

			map("n", "[c", function()
				if vim.wo.diff then
					vim.cmd.normal({ "[c", bang = true })
				else
					gitsigns.nav_hunk("prev")
				end
			end, { desc = "Prev hunk" })

			-- float window is less noisy as opposed to
			-- gitsigns.preview_hunk_inline
			map("n", "<leader>dp", gitsigns.preview_hunk, { desc = "Preview hunk" })

			map({ "o", "x" }, "ih", gitsigns.select_hunk, { desc = "Select hunk" })
			map({ "o", "x" }, "ah", gitsigns.select_hunk, { desc = "Select hunk" })
		end,
	},

	init = function()
		-- It is linked to NonText by default which is too light
		vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { link = "Comment" })
	end,
}
