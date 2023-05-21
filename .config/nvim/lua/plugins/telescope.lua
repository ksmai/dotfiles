return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.1",
    dependencies = {
        "nvim-lua/plenary.nvim",
        {"nvim-telescope/telescope-fzf-native.nvim", build = "make"},
        {"nvim-telescope/telescope-dap.nvim"}
    },
    keys = {
        {
            "<C-p>",
            function()
                require("telescope.builtin").find_files({
                    find_command = {
                        "rg", "--files", "--hidden", "--iglob", "!.git/"
                    }
                })
            end,
            mode = "n",
            noremap = true,
            silent = true,
            desc = "Find files"
        }, {
            "<leader>ff",
            function()
                require("telescope.builtin").find_files({
                    find_command = {
                        "rg", "--files", "--hidden", "--iglob", "!.git/"
                    }
                })
            end,
            mode = "n",
            noremap = true,
            silent = true,
            desc = "Find files"
        }, {
            "<leader>fF",
            function()
                require("telescope.builtin").find_files({
                    find_command = {
                        "rg", "--files", "--hidden", "--iglob", "!.git/"
                    },
                    cwd = require("telescope.utils").buffer_dir()
                })
            end,
            mode = "n",
            noremap = true,
            silent = true,
            desc = "Find files (cwd)"
        }, {
            "<leader>fg",
            function() require("telescope.builtin").live_grep() end,
            mode = "n",
            noremap = true,
            silent = true,
            desc = "Find strings"
        }, {
            "<leader>fG",
            function()
                require("telescope.builtin").live_grep({
                    cwd = require("telescope.utils").buffer_dir()
                })
            end,
            mode = "n",
            noremap = true,
            silent = true,
            desc = "Find strings (cwd)"
        }, {
            "<leader>f*",
            function() require("telescope.builtin").grep_string() end,
            mode = "n",
            noremap = true,
            silent = true,
            desc = "Find string under cursor"
        }, {
            "<leader>f*",
            [["ty<cmd>exec 'Telescope grep_string default_text=' . escape(@t, ' ')<cr>]],
            mode = "v",
            noremap = true,
            silent = true,
            desc = "Find string under cursor"
        }, {
            "<leader>fb",
            "<cmd>Telescope dap list_breakpoints<cr>",
            mode = "n",
            noremap = true,
            silent = true,
            desc = "Find breakpoints"
        }, {
            "<leader>fd",
            "<cmd>Telescope dap commands<cr>",
            mode = "n",
            noremap = true,
            silent = true,
            desc = "Find DAP commands"
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
                }
            }
        }
    end,
    config = function(_, opts)
        local telescope = require("telescope")
        telescope.setup(opts)
        telescope.load_extension("fzf")
        telescope.load_extension("dap")
    end
}
