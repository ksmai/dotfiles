local function codeFormat()
    local buf = vim.api.nvim_get_current_buf()
    local ft = vim.bo[buf].filetype
    local have_nls = #require("null-ls.sources").get_available(ft, "NULL_LS_FORMATTING") > 0

    vim.lsp.buf.format({
        bufnr = buf,
        filter = function(client)
            if have_nls then
                return client.name == "null-ls"
            end
            return client.name ~= "null-ls"
        end,
    })
end


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
        config = function(_, opts)
            vim.opt.timeout = true
            vim.opt.timeoutlen = 500
            local wk = require("which-key")
            wk.setup(opts)
            wk.register({
                ["<leader>c"] = { name = "+code" },
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
    },

    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            {
                "folke/neodev.nvim",
                opts = { experimental = { pathStrict = true } },
            },
            "williamboman/mason.nvim",
            { "williamboman/mason-lspconfig.nvim" },
            { "hrsh7th/cmp-nvim-lsp" },
            "hrsh7th/nvim-cmp",
            "SmiteshP/nvim-navic",
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
                    on_attach = function(_, bufnr)
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
                    callback = codeFormat,
                })
            end

            local function on_attach_copilot(client, _)
                if client.name == "copilot" then
                    local copilot_cmp = require("copilot_cmp")
                    copilot_cmp._on_insert_enter()
                end
            end

            local function on_attach_keymaps(_, bufnr)
                -- Mappings.
                -- See `:help vim.lsp.*` for documentation on any of the below functions
                local bufopts = { noremap = true, silent = true, buffer = bufnr }
                local function desc(d)
                    return vim.tbl_extend("force", bufopts, { desc = d })
                end

                vim.keymap.set('n', 'gd', "<cmd>Telescope lsp_definitions<cr>", desc("Go definitions"))
                vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, desc("Go declarations"))
                vim.keymap.set('n', 'gy', "<cmd>Telescope lsp_type_definitions<cr>", desc("Go t[y]pe definitions"))
                vim.keymap.set('n', 'gI', "<cmd>Telescope lsp_implementations<cr>", desc("Go implementations"))
                vim.keymap.set('n', 'gr', "<cmd>Telescope lsp_references<cr>", desc("Go references"))
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, desc("Hover"))
                vim.keymap.set({ 'n', 'i' }, '<C-k>', vim.lsp.buf.signature_help, desc("Signature help"))
                vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, desc("Code rename"))
                vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, desc("Code action"))
                vim.keymap.set('n', '<leader>cf', codeFormat, desc("Code format"))
                vim.keymap.set('v', '<leader>cf', codeFormat, desc("Code format in range"))
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
                    on_attach_keymaps(client, bufnr)
                    on_attach_copilot(client, bufnr)
                    if client.server_capabilities.documentSymbolProvider then
                        require("nvim-navic").attach(client, bufnr)
                    end
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

    {
        "jose-elias-alvarez/null-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "williamboman/mason.nvim", "nvim-lua/plenary.nvim" },
        opts = function()
            local nls = require("null-ls")
            return {
                root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
                sources = {
                    -- nls.builtins.formatting.fish_indent,
                    -- nls.builtins.diagnostics.fish,
                    -- nls.builtins.formatting.stylua,
                    -- nls.builtins.formatting.shfmt,
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

    {
        "L3MON4D3/LuaSnip",
        build = (not jit.os:find("Windows"))
            and "echo -e 'NOTE: jsregexp is optional, so not a big deal if it fails to build\n'; make install_jsregexp"
            or nil,
        dependencies = {
            "rafamadriz/friendly-snippets",
            config = function()
                require("luasnip.loaders.from_vscode").lazy_load()
            end,
        },
        opts = {
            history = true,
            delete_check_events = "TextChanged",
        },
    },

    {
        "hrsh7th/nvim-cmp",
        version = false, -- last release is way too old
        -- event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "saadparwaiz1/cmp_luasnip",
            "zbirenbaum/copilot-cmp",
            "ray-x/lsp_signature.nvim",
        },
        keys = {
            -- https://github.com/neovim/nvim-lspconfig#suggested-configuration
            -- Mappings.
            -- See `:help vim.diagnostic.*` for documentation on any of the below functions
            {
                '<leader>cd',
                vim.diagnostic.open_float,
                mode = "n",
                noremap = true,
                silent = true,
                desc = "Code diagnostic",
            },
            {
                '<leader>cq',
                vim.diagnostic.setqflist,
                mode = "n",
                noremap = true,
                silent = true,
                desc = "Code quickfix list",
            },
            {
                '<leader>cl',
                vim.diagnostic.setloclist,
                mode = "n",
                noremap = true,
                silent = true,
                desc = "Code location list",
            },
            {
                '[d',
                vim.diagnostic.goto_prev,
                mode = "n",
                noremap = true,
                silent = true,
                desc = "Go to prev diagnostic",
            },
            {
                ']d',
                vim.diagnostic.goto_next,
                mode = "n",
                noremap = true,
                silent = true,
                desc = "Go to next diagnostic",
            },
        },
        opts = function()
            local has_words_before = function()
                unpack = unpack or table.unpack
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and
                    vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end

            local cmp = require("cmp")
            local luasnip = require("luasnip")

            return {
                completion = {
                    completeopt = "menu,menuone,noinsert",
                },
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    -- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#super-tab-like-mapping
                    ["<C-n>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
                        elseif has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<C-p>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
                        elseif has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    -- ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    -- ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                    -- ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    -- ["<C-d>"] = cmp.mapping.scroll_docs(4),
                    -- ["<C-e>"] = cmp.mapping.abort(),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                            cmp.confirm({
                                behavior = cmp.ConfirmBehavior.Insert,
                                select = true,
                            })
                        elseif luasnip.expand_or_locally_jumpable() then
                            -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
                            -- they way you will only jump inside the snippet region
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        elseif cmp.visible() then
                            -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                            cmp.confirm({
                                behavior = cmp.ConfirmBehavior.Insert,
                                select = true,
                            })
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<CR>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                }),
                sources = cmp.config.sources({
                    { name = "copilot", group_index = 2 },
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "buffer" },
                    { name = "path" },
                }),
                formatting = {
                    format = function(_, item)
                        local icons = {
                            Array = " ",
                            Boolean = " ",
                            Class = " ",
                            Color = " ",
                            Constant = " ",
                            Constructor = " ",
                            Copilot = " ",
                            Enum = " ",
                            EnumMember = " ",
                            Event = " ",
                            Field = " ",
                            File = " ",
                            Folder = " ",
                            Function = " ",
                            Interface = " ",
                            Key = " ",
                            Keyword = " ",
                            Method = " ",
                            Module = " ",
                            Namespace = " ",
                            Null = " ",
                            Number = " ",
                            Object = " ",
                            Operator = " ",
                            Package = " ",
                            Property = " ",
                            Reference = " ",
                            Snippet = " ",
                            String = " ",
                            Struct = " ",
                            Text = " ",
                            TypeParameter = " ",
                            Unit = " ",
                            Value = " ",
                            Variable = " ",
                        }
                        if icons[item.kind] then
                            item.kind = icons[item.kind] .. item.kind
                        end
                        return item
                    end,
                },
                experimental = {
                    ghost_text = {
                        hl_group = "LspCodeLens",
                    },
                },
                sorting = {
                    priority_weight = 2,
                    comparators = {
                        require("copilot_cmp.comparators").prioritize,

                        -- Below is the default comparitor list and order for nvim-cmp
                        cmp.config.compare.offset,
                        -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
                        cmp.config.compare.exact,
                        cmp.config.compare.score,
                        cmp.config.compare.recently_used,
                        cmp.config.compare.locality,
                        cmp.config.compare.kind,
                        cmp.config.compare.sort_text,
                        cmp.config.compare.length,
                        cmp.config.compare.order,
                    },
                },
            }
        end,
        config = function(_, opts)
            local cmp = require("cmp")
            cmp.setup(opts)

            -- Set configuration for specific filetype.
            cmp.setup.filetype('gitcommit', {
                sources = cmp.config.sources({
                    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
                }, {
                    { name = 'buffer' },
                })
            })
        end,
    },

    { "nvim-lua/plenary.nvim", lazy = true },

    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.1',
        dependencies = { 'nvim-lua/plenary.nvim' },
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
            require('telescope').setup(opts)
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
            { "RRethy/nvim-base16" },
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
        'nvim-tree/nvim-web-devicons',
        opts = {
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
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        build = ":Copilot auth",
        opts = {
            suggestion = { enabled = false },
            panel = { enabled = false },
        },
    },

    {
        "zbirenbaum/copilot-cmp",
        dependencies = { "zbirenbaum/copilot.lua" },
        opts = {},
    },

    {
        "ray-x/lsp_signature.nvim",
        opts = {},
    },
}
