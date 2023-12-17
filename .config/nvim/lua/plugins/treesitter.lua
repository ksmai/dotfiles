return {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
    build = ":TSUpdate",
    event = {"BufReadPost", "BufNewFile"},
    dependencies = {
        {"nvim-treesitter/nvim-treesitter-textobjects"},
        {"RRethy/nvim-treesitter-textsubjects"},
        {'JoosepAlviste/nvim-ts-context-commentstring'}
    },
    keys = {
        {"<leader>v", desc = "Increment selection"},
        {"v", desc = "Increment selection"},
        {"<bs>", desc = "Decrement selection", mode = "x"}
    },
    opts = {
        ensure_installed = {
            "bash", "comment", "css", "diff", "dockerfile", "fish",
            "git_config", "git_rebase", "gitattributes", "gitcommit",
            "gitignore", "glsl", "html", "javascript", "json", "lua", "make",
            "markdown", "markdown_inline", "mermaid", "pug", "python", "regex",
            "rust", "scss", "sql", "svelte", "tsx", "typescript", "vue", "yaml",
            "c_sharp"
        },
        highlight = {enable = true},
        indent = {enable = true},
        context_commentstring = {enable = true, enable_autocmd = false},
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<cr>",
                node_incremental = "<cr>",
                scope_incremental = false,
                node_decremental = "<bs>"
            }
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
                    ["am"] = "@comment.outer"
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
                    ['@comment.outer'] = 'v'
                },
                include_surrounding_whitespace = false
            },
            swap = {
                enable = true,
                swap_next = {["<leader>>"] = "@parameter.inner"},
                swap_previous = {["<leader><"] = "@parameter.inner"}
            },
            move = {
                enable = true,
                set_jumps = true,
                goto_next_start = {
                    ["]]"] = {query = {"@class.outer", "@function.outer"}}
                },
                goto_next_end = {
                    ["]["] = {query = {"@class.outer", "@function.outer"}}
                },
                goto_previous_start = {
                    ["[["] = {query = {"@class.outer", "@function.outer"}}
                },
                goto_previous_end = {
                    ["[]"] = {query = {"@class.outer", "@function.outer"}}
                }
            },
            lsp_interop = {
                enable = true,
                border = 'none',
                floating_preview_opts = {},
                peek_definition_code = {
                    ["<leader>cF"] = "@function.outer",
                    ["<leader>cC"] = "@class.outer"
                }
            }
        },
        textsubjects = {
            enable = true,
            keymaps = {
                ['<cr>'] = 'textsubjects-smart',
                ['a<cr>'] = 'textsubjects-container-outer',
                ['i<cr>'] = 'textsubjects-container-inner'
            }
        }
    },
    config = function(_, opts) require("nvim-treesitter.configs").setup(opts) end
}
