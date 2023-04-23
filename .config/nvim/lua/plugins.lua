return {
    {
        "chriskempson/base16-vim",
        lazy = false,    -- make sure we load this during startup if it is your main colorscheme
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
        config = function()
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
            { "v",    desc = "Increment selection" },
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
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,
    },

    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            { "folke/neodev.nvim",                opts = { experimental = { pathStrict = true } } },
            "williamboman/mason.nvim",
            { "williamboman/mason-lspconfig.nvim" },
            { "hrsh7th/cmp-nvim-lsp" },
        },
        opts = {
            diagnostics = {
                underline = true,
                update_in_insert = false,
                virtual_text = {
                    spacing = 4,
                    source = "if_many",
                    prefix = "●",
                },
                severity_sort = true,
            },
            capabilities = {},
            autoformat = true,
            servers = {
                jsonls = {},
                lua_ls = {
                    settings = {
                        Lua = {
                            telemetry = {
                                enable = false,
                            },
                            runtime = {
                                version = "LuaJIT"
                            },
                            workspace = {
                                checkThirdParty = false
                            }
                        },
                    },
                },
                rust_analyzer = {
                    settings = {
                        ["rust-analyzer"] = {
                            checkOnSave = {
                                command = "clippy",
                            },
                        },
                    },
                },
                pylsp = {
                },
                tsserver = {
                },
                eslint = {
                    on_attach = function(client, bufnr)
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            buffer = bufnr,
                            command = "EslintFixAll",
                        })
                    end
                },
                svelte = {
                },
            },
            setup = {
                -- example to setup with typescript.nvim
                -- tsserver = function(_, opts)
                --   require("typescript").setup({ server = opts })
                --   return true
                -- end,
                -- Specify * to use this function as a fallback for any server
                -- ["*"] = function(server, opts) end,
            },
        },
        config = function(_, opts)
            vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

            local servers = opts.servers
            local capabilities = vim.tbl_deep_extend(
                "force",
                {},
                vim.lsp.protocol.make_client_capabilities(),
                require("cmp_nvim_lsp").default_capabilities(),
                opts.capabilities or {}
            )

            local function on_attach_fmt(client, bufnr)
                if not opts.autoformat then
                    return
                end

                if
                    client.config
                    and client.config.capabilities
                    and client.config.capabilities.documentFormattingProvider == false
                then
                    return
                end

                if not client.supports_method("textDocument/formatting") then
                    return
                end

                vim.api.nvim_create_autocmd("BufWritePre", {
                    group = vim.api.nvim_create_augroup("ksmai_lsp_format." .. bufnr, {}),
                    buffer = bufnr,
                    callback = function()
                        local buf = vim.api.nvim_get_current_buf()
                        local ft = vim.bo[buf].filetype
                        local have_nls = #require("null-ls.sources").get_available(ft, "NULL_LS_FORMATTING") > 0

                        vim.lsp.buf.format({
                            bufnr = buf,
                            filter = function(client2)
                                if have_nls then
                                    return client2.name == "null-ls"
                                end
                                return client2.name ~= "null-ls"
                            end,
                        })
                    end,
                })
            end

            local function setup(server)
                local server_config = servers[server] or {}
                local server_opts = vim.tbl_deep_extend("force", {
                    capabilities = vim.deepcopy(capabilities),
                }, server_config)

                local function on_attach(client, bufnr)
                    if server_config.on_attach ~= nil then
                        server_config.on_attach(client, bufnr)
                    end
                    on_attach_fmt(client, bufnr)
                end

                server_opts.on_attach = on_attach

                if opts.setup[server] then
                    if opts.setup[server](server, server_opts) then
                        return
                    end
                elseif opts.setup["*"] then
                    if opts.setup["*"](server, server_opts) then
                        return
                    end
                end
                require("lspconfig")[server].setup(server_opts)
            end

            local mlsp = require("mason-lspconfig")
            local all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
            local ensure_installed = {}

            for server, server_opts in pairs(servers) do
                if server_opts then
                    server_opts = server_opts == true and {} or server_opts
                    -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
                    if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
                        setup(server)
                    else
                        ensure_installed[#ensure_installed + 1] = server
                    end
                end
            end

            mlsp.setup({ ensure_installed = ensure_installed })
            mlsp.setup_handlers({ setup })
        end,
    },

    -- formatters
    {
        "jose-elias-alvarez/null-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "williamboman/mason.nvim", "nvim-lua/plenary.nvim" },
        opts = function()
            local nls = require("null-ls")
            return {
                root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
                sources = {
                    nls.builtins.formatting.fish_indent,
                    nls.builtins.diagnostics.fish,
                    nls.builtins.formatting.stylua,
                    nls.builtins.formatting.shfmt,
                    -- nls.builtins.diagnostics.flake8,
                },
            }
        end,
    },

    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        config = function()
            require("mason").setup()
        end,
    },

    { "nvim-lua/plenary.nvim", lazy = true },
}
