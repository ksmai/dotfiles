return {
    {
        "tpope/vim-commentary",
        event = "VeryLazy",
    },

    {
        "tpope/vim-unimpaired",
        event = "VeryLazy",
    },

    {
        "tpope/vim-repeat",
        event = "VeryLazy",
    },

    {
        "tpope/vim-rsi",
        event = "VeryLazy",
    },

    { "nvim-lua/plenary.nvim", lazy = true },

    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.1',
        dependencies = {
            'nvim-lua/plenary.nvim',
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
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
            local builtin = require("telescope.builtin")
            local utils = require("telescope.utils")
            local find_command = { "rg", "--files", "--hidden", "--iglob", "!.git/" }
            vim.keymap.set("n", "<C-p>", function() builtin.find_files({ find_command = find_command }) end, {
                noremap = true,
                silent = true,
                desc = "Find files",
            })
            vim.keymap.set("n", "<leader>ff", function() builtin.find_files({ find_command = find_command }) end, {
                noremap = true,
                silent = true,
                desc = "Find files",
            })
            vim.keymap.set("n", "<leader>fF",
                function() builtin.find_files({ find_command = find_command, cwd = utils.buffer_dir() }) end, {
                    noremap = true,
                    silent = true,
                    desc = "Find files (cwd)",
                })
            vim.keymap.set("n", "<leader>fg", function() builtin.live_grep() end, {
                noremap = true,
                silent = true,
                desc = "Grep files",
            })
            vim.keymap.set("n", "<leader>fG", function() builtin.live_grep({ cwd = utils.buffer_dir() }) end, {
                noremap = true,
                silent = true,
                desc = "Grep files (cwd)",
            })
            vim.keymap.set("n", "<leader>f*", function() builtin.grep_string() end, {
                noremap = true,
                silent = true,
                desc = "Search selected string",
            })
        end
    },

    {
        'nvim-lualine/lualine.nvim',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
        },
        opts = {
            sections = {
                lualine_b = { "FugitiveStatusline", 'diff', 'diagnostics' },
            },
            winbar = {
                lualine_c = {
                    "navic",
                    color_correction = nil,
                    navic_opts = nil
                },
                lualine_x = {
                    function()
                        if #vim.lsp.get_active_clients() == 0 then
                            return ""
                        end

                        local lsp = vim.lsp.util.get_progress_messages()[1]
                        if lsp then
                            local name = lsp.name or ""
                            local msg = lsp.message or ""
                            local percentage = lsp.percentage or 0
                            local title = lsp.title or ""
                            return string.format(" %%<%s: %s %s (%s%%%%) ", name, title, msg, percentage)
                        end

                        return ""
                    end,
                },
            }
        },
    },

    {
        "MunifTanjim/nui.nvim",
        lazy = true,
    },

    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
        },
        keys = {
            { "<C-n>", "<cmd>Neotree toggle<cr>", mode = "n", noremap = true, silent = true, desc = "Toggle Neotree" },
        },
        opts = {
            filesystem = {
                filtered_items = {
                    hide_dotfiles = false,
                },
            },
        },
        init = function()
            vim.g.neo_tree_remove_legacy_commands = 1
        end,
    },
}
