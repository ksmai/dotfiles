return {
    "nvim-treesitter/nvim-treesitter",
    version = false,     -- last release is way too old and doesn't work on Windows
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
        { "nvim-treesitter/nvim-treesitter-textobjects" },
        { 'JoosepAlviste/nvim-ts-context-commentstring' },
    },
    keys = {
        { "<leader>v", desc = "Increment selection" },
        { "v",         desc = "Increment selection" },
        { "<bs>",      desc = "Decrement selection", mode = "x" },
    },
    opts = {
        highlight = { enable = true },
        indent = { enable = true },
        context_commentstring = { enable = true, enable_autocmd = false },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<leader>v",
                node_incremental = "v",
                scope_incremental = false,
                node_decremental = "<bs>",
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
                    ["<leader>cF"] = "@function.outer",
                    ["<leader>cC"] = "@class.outer",
                },
            },
        },
    },
    config = function(_, opts)
        require("nvim-treesitter.configs").setup(opts)
    end,
}