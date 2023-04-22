return {
    {
        "chriskempson/base16-vim",
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            -- load the colorscheme here
            if vim.fn.exists("$BASE16_THEME") then
                vim.cmd("colorscheme base16-" .. os.getenv("BASE16_THEME"))
            end
        end,
    },

    {
        "folke/which-key.nvim",
        config = function()
            vim.opt.timeout = true
            vim.opt.timeoutlen = 500
            require("which-key").setup({
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
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
        config = function(_, opts)
            vim.keymap.set("n", "<leader>gs", "<cmd>Git<cr><C-w>_", {
                noremap = true,
                silent = true,
            })
            vim.keymap.set("n", "<leader>gd", "<cmd>Gvdiffsplit<cr>", {
                noremap = true,
                silent = true,
            })
            vim.keymap.set("n", "<leader>gl", "<cmd>0Gclog<cr>", {
                noremap = true,
                silent = true,
            })
            vim.keymap.set("v", "<leader>gl", ":Gclog<cr>", {
                noremap = true,
                silent = true,
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
        "tpope/vim-surround",
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

    {
        "nvim-treesitter/nvim-treesitter",
        version = false, -- last release is way too old and doesn't work on Windows
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = {
            { "nvim-treesitter/nvim-treesitter-textobjects" },
            { 'JoosepAlviste/nvim-ts-context-commentstring' },
        },
        keys = {
            { "v", desc = "Increment selection" },
            { "<bs>", desc = "Decrement selection", mode = "x" },
        },
        opts = {
            highlight = { enable = true },
            indent = { enable = true },
            context_commentstring = { enable = true, enable_autocmd = false },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = false,
                    node_incremental = "v",
                    scope_incremental = false,
                    node_decremental = "<S-v>",
                },
            },
            textobjects = {
                select = {
                    enable = true,
                    -- Automatically jump forward to textobj, similar to targets.vim
                    lookahead = true,
                    keymaps = {
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = "@class.inner",
                        ["ai"] = "@conditional.outer",
                        ["ii"] = "@conditional.inner",
                        ["al"] = "@loop.outer",
                        ["il"] = "@loop.inner",
                        ["am"] = "@comment.outer",
                    },
                    selection_modes = {
                        ['@function.outer'] = 'V',
                        ['@function.inner'] = 'V',
                        ['@class.outer'] = 'V',
                        ['@class.inner'] = 'V',
                        ['@conditional.outer'] = 'V',
                        ['@conditional.inner'] = 'V',
                        ['@loop.outer'] = 'V',
                        ['@loop.inner'] = 'V',
                        ['@comment.outer'] = 'v',
                    },
                    include_surrounding_whitespace = false,
                },
                swap = {
                    enable = true,
                    swap_next = {
                        ["<leader>>"] = "@parameter.inner",
                    },
                    swap_previous = {
                        ["<leader><"] = "@parameter.inner",
                    },
                },
                move = {
                    enable = true,
                    set_jumps = true,
                    goto_next_start = {
                        ["]]"] = { query = { "@class.outer", "@function.outer" } }
                    },
                    goto_next_end = {
                        ["]["] = { query = { "@class.outer", "@function.outer" } }
                    },
                    goto_previous_start = {
                        ["[["] = { query = { "@class.outer", "@function.outer" } }
                    },
                    goto_previous_end = {
                        ["[]"] = { query = { "@class.outer", "@function.outer" } }
                    },
                },
                lsp_interop = {
                    enable = true,
                    border = 'none',
                    floating_preview_opts = {},
                    peek_definition_code = {
                        ["<leader>df"] = "@function.outer",
                        ["<leader>dc"] = "@class.outer",
                    },
                },
            },
            context_commentstring = {
                enable = true,
            },
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,
    },
}
