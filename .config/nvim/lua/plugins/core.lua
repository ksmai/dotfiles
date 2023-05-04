return {
    {
        "folke/which-key.nvim",
        config = function(_, opts)
            vim.opt.timeout = true
            vim.opt.timeoutlen = 500
            local wk = require("which-key")
            wk.setup(opts)
            wk.register({
                ["<leader>c"] = { name = "+code" },
                ["<leader>d"] = { name = "+diff" },
                ["<leader>f"] = { name = "+find" },
                ["<leader>g"] = { name = "+git" },
            })
        end,
    },

    {
        "echasnovski/mini.pairs",
        event = "VeryLazy",
        config = function(_, opts)
            require("mini.pairs").setup(opts)
        end,
    },

    {
        "tpope/vim-fugitive",
        event = "VeryLazy",
        dependencies = { { "tpope/vim-rhubarb" } },
        config = function()
            vim.keymap.set("n", "<leader>gs", "<cmd>Git<cr><C-w>_", {
                noremap = true,
                silent = true,
                desc = "Git status",
            })
            vim.keymap.set("n", "<leader>gd", "<cmd>Gvdiffsplit !^<cr>", {
                noremap = true,
                silent = true,
                desc = "Git diff against parent",
            })
            vim.keymap.set("n", "<leader>gl", "<cmd>0Gclog<cr>", {
                noremap = true,
                silent = true,
                desc = "Git log",
            })
            vim.keymap.set("v", "<leader>gl", ":Gclog<cr>", {
                noremap = true,
                silent = true,
                desc = "Git log (selected lines)",
            })
            vim.keymap.set("n", "<leader>gb", "<cmd>Git blame --date=relative<cr>", {
                noremap = true,
                silent = true,
                desc = "Git blame",
            })
            vim.keymap.set("n", "<leader>gp", "<cmd>Git log --patch -- %<cr>", {
                noremap = true,
                silent = true,
                desc = "Git log with patch",
            })
            vim.keymap.set("v", "<leader>gp",
                [[<esc><cmd>lua vim.cmd("Git log --patch -L" .. vim.api.nvim_buf_get_mark(0, "<")[1] .. "," .. vim.api.nvim_buf_get_mark(0, ">")[1] .. ":%")<cr>]],
                {
                    noremap = true,
                    silent = true,
                    desc = "Git log with patch",
                })
        end,
    },

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

    {
        'phaazon/hop.nvim',
        branch = 'v2',
        config = function(_, opts)
            local hop = require('hop')
            hop.setup(opts)

            vim.keymap.set("n", "\\", function()
                hop.hint_char2()
            end, { silent = true, noremap = true, desc = "Hop" })

            vim.keymap.set("n", "g\\", function()
                hop.hint_char2({ multi_windows = true })
            end, { silent = true, noremap = true, desc = "Hop multi-windows" })
        end
    },
}
