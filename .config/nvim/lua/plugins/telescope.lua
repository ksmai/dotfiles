return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.1',
    dependencies = {
        'nvim-lua/plenary.nvim',
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    keys = {
        {
            "<C-p>",
            function()
                require("telescope.builtin").find_files({
                    find_command = { "rg", "--files", "--hidden", "--iglob", "!.git/" } })
            end,
            mode = "n",
            noremap = true,
            silent = true,
            desc = "Find files",
        },
        {
            "<leader>ff",
            function()
                require("telescope.builtin").find_files({
                    find_command = { "rg", "--files", "--hidden", "--iglob", "!.git/" } })
            end,
            mode = "n",
            noremap = true,
            silent = true,
            desc = "Find files",
        },
        {
            "<leader>fF",
            function()
                require("telescope.builtin").find_files({
                    find_command = { "rg", "--files", "--hidden", "--iglob", "!.git/" },
                    cwd = require('telescope.utils').buffer_dir()
                })
            end,
            mode = "n",
            noremap = true,
            silent = true,
            desc = "Find files (cwd)",
        },
        {
            "<leader>fg",
            function() require("telescope.builtin").live_grep() end,
            mode = "n",
            noremap = true,
            silent = true,
            desc = "Grep files",
        },
        {
            "<leader>fG",
            function() require("telescope.builtin").live_grep({ cwd = require('telescope.utils').buffer_dir() }) end,
            mode = "n",
            noremap = true,
            silent = true,
            desc = "Grep files (cwd)",
        },
        {
            "<leader>f*",
            function() require("telescope.builtin").grep_string() end,
            mode = "n",
            noremap = true,
            silent = true,
            desc = "Search selected string",
        },
    },
    opts = function()
        local actions = require("telescope.actions")
        return {
            defaults = {
                mappings = {
                    i = {
                        ["<esc>"] = actions.close,
                    },
                },
                vimgrep_arguments = {
                    'rg',
                    '--smart-case',
                    '--no-heading',
                    '--vimgrep',
                    '--hidden',
                    '--iglob',
                    '!.git/',
                },
            },
        }
    end,
    config = function(_, opts)
        local telescope = require('telescope')
        telescope.setup(opts)
        telescope.load_extension('fzf')
    end
}
