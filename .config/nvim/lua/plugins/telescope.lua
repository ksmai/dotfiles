local function dropdown(opts)
    return require('telescope.themes').get_dropdown(opts)
end

return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.1",
    dependencies = {
        "nvim-lua/plenary.nvim", {"nvim-telescope/telescope-ui-select.nvim"},
        {"nvim-telescope/telescope-fzf-native.nvim", build = "make"}
    },
    keys = {
        {
            "<C-p>",
            function()
                require("telescope.builtin").find_files(dropdown({
                    find_command = {
                        "rg", "--files", "--hidden", "--iglob", "!.git/"
                    }
                }))
            end,
            mode = "n",
            noremap = true,
            silent = true,
            desc = "Find files"
        }, {
            "<leader>fg",
            function()
                require("telescope.builtin").grep_string(dropdown({search = ""}))
            end,
            mode = "n",
            noremap = true,
            silent = true,
            desc = "Fuzzy search"
        }, {
            "<leader>fG",
            function()
                require("telescope.builtin").live_grep(dropdown({}))
            end,
            mode = "n",
            noremap = true,
            silent = true,
            desc = "Live grep"
        }, {
            "<leader>fw",
            function()
                require("telescope.builtin").live_grep(dropdown({
                    default_text = vim.fn.expand("<cword>")
                }))
            end,
            mode = "n",
            noremap = true,
            silent = true,
            desc = "Find word under cursor"
        }, {
            "<leader>fW",
            function()
                require("telescope.builtin").live_grep(dropdown({
                    default_text = vim.fn.expand("<cWORD>")
                }))
            end,
            mode = "n",
            noremap = true,
            silent = true,
            desc = "Find WORD under cursor"
        }, {
            "<leader>fw",
            function()
                local start_col = vim.fn.col("v")
                local end_col = vim.fn.col(".")
                if end_col < start_col then
                    start_col, end_col = end_col, start_col
                end
                local start = start_col - 1
                local length = end_col - start_col + 1
                local line = vim.fn.getline(".")
                local default_text = vim.fn.strpart(line, start, length)
                require("telescope.builtin").live_grep(dropdown({
                    default_text = default_text
                }))
            end,
            mode = "v",
            noremap = true,
            silent = true,
            desc = "Find selected word"
        }, {
            "<leader>fc",
            function()
                require("telescope.builtin").commands(dropdown({}))
            end,
            mode = "n",
            noremap = true,
            silent = true,
            desc = "Find commands"
        }, {
            "<leader>fC",
            function()
                require("telescope.builtin").command_history(dropdown({}))
            end,
            mode = "n",
            noremap = true,
            silent = true,
            desc = "Find command history"
        }, {
            "<leader>fh",
            function()
                require("telescope.builtin").help_tags(dropdown({}))
            end,
            mode = "n",
            noremap = true,
            silent = true,
            desc = "Find help tags"
        }, {
            "<leader>fr",
            function()
                require("telescope.builtin").resume(dropdown({}))
            end,
            mode = "n",
            noremap = true,
            silent = true,
            desc = "Resume previous picker"
        }, {
            "<leader>fR",
            function()
                require("telescope.builtin").pickers(dropdown({}))
            end,
            mode = "n",
            noremap = true,
            silent = true,
            desc = "Resume previous pickers"
        }, {
            "<leader>fz",
            function()
                local opts = dropdown({})
                require("telescope.builtin").current_buffer_fuzzy_find(opts)
            end,
            mode = "n",
            noremap = true,
            silent = true,
            desc = "Fuzzy search (current file)"
        }
    },
    opts = function()
        local actions = require("telescope.actions")
        return {
            defaults = {
                mappings = {i = {["<esc>"] = actions.close}},
                vimgrep_arguments = {
                    "rg", "--smart-case", "--no-heading", "--vimgrep",
                    "--hidden", "--iglob", "!.git/"
                },
                cache_picker = {num_pickers = 5}
            },
            extensions = {
                ["ui-select"] = {require("telescope.themes").get_dropdown({})}
            }
        }
    end,
    config = function(_, opts)
        local telescope = require("telescope")
        telescope.setup(opts)
        telescope.load_extension("fzf")
        telescope.load_extension("ui-select")
    end
}
