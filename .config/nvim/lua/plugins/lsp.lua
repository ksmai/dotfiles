local function codeFormat()
    local buf = vim.api.nvim_get_current_buf()
    local ft = vim.bo[buf].filetype
    local have_nls = #require("null-ls.sources").get_available(ft,
                                                               "NULL_LS_FORMATTING") >
                         0

    vim.lsp.buf.format({
        bufnr = buf,
        filter = function(client)
            if have_nls then return client.name == "null-ls" end

            local has_eslint = #vim.lsp.get_active_clients({
                bufnr = 0,
                name = "eslint"
            }) > 0
            return client.name ~= "null-ls" and
                       (not has_eslint or client.name ~= "tsserver")
        end
    })
end

return {
    {
        "neovim/nvim-lspconfig",
        event = {"BufReadPre", "BufNewFile"},
        dependencies = {
            {"folke/neodev.nvim", opts = {experimental = {pathStrict = true}}},
            "williamboman/mason.nvim", {"williamboman/mason-lspconfig.nvim"},
            "SmiteshP/nvim-navic", "hrsh7th/nvim-cmp", "ibhagwan/fzf-lua"
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
                desc = "Code diagnostic"
            }, {
                '<leader>cD',
                function()
                    local virtual_text = vim.diagnostic.config().virtual_text
                    if virtual_text then
                        vim.diagnostic.config({virtual_text = false})
                    else
                        vim.diagnostic.config({
                            virtual_text = {
                                spacing = 4,
                                source = "if_many",
                                prefix = "●"
                            }
                        })
                    end
                end,
                mode = "n",
                noremap = true,
                silent = true,
                desc = "Toggle virtual text"
            }, {
                '<leader>cq',
                vim.diagnostic.setqflist,
                mode = "n",
                noremap = true,
                silent = true,
                desc = "Code quickfix list"
            }, {
                '<leader>cl',
                vim.diagnostic.setloclist,
                mode = "n",
                noremap = true,
                silent = true,
                desc = "Code location list"
            }, {
                '[d',
                vim.diagnostic.goto_prev,
                mode = "n",
                noremap = true,
                silent = true,
                desc = "Go to prev diagnostic"
            }, {
                ']d',
                vim.diagnostic.goto_next,
                mode = "n",
                noremap = true,
                silent = true,
                desc = "Go to next diagnostic"
            }
        },
        opts = {
            diagnostics = {
                underline = true,
                update_in_insert = false,
                virtual_text = {spacing = 4, source = "if_many", prefix = "●"},
                severity_sort = true
            },
            capabilities = {},
            autoformat = true,
            servers = {
                jsonls = {},
                lua_ls = {
                    settings = {
                        Lua = {
                            telemetry = {enable = false},
                            runtime = {version = "LuaJIT"},
                            workspace = {checkThirdParty = false}
                        }
                    }
                },
                rust_analyzer = {
                    settings = {
                        ["rust-analyzer"] = {checkOnSave = {command = "clippy"}}
                    }
                },
                pylsp = {},
                tsserver = {},
                eslint = {
                    on_attach = function(_, bufnr)
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            buffer = bufnr,
                            command = "EslintFixAll"
                        })
                    end
                },
                svelte = {}
            },
            setup = {
                -- example to setup with typescript.nvim
                -- tsserver = function(_, opts)
                --   require("typescript").setup({ server = opts })
                --   return true
                -- end,
                -- Specify * to use this function as a fallback for any server
                -- ["*"] = function(server, opts) end,
            }
        },
        config = function(_, opts)
            vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

            local servers = opts.servers
            local capabilities = vim.tbl_deep_extend("force", {}, vim.lsp
                                                         .protocol
                                                         .make_client_capabilities(),
                                                     require("cmp_nvim_lsp").default_capabilities(),
                                                     opts.capabilities or {})

            local function on_attach_fmt(client, bufnr)
                if not opts.autoformat then return end

                if client.config and client.config.capabilities and
                    client.config.capabilities.documentFormattingProvider ==
                    false then return end

                if not client.supports_method("textDocument/formatting") then
                    return
                end

                vim.api.nvim_create_autocmd("BufWritePre", {
                    group = vim.api.nvim_create_augroup(
                        "ksmai_lsp_format." .. bufnr, {}),
                    buffer = bufnr,
                    callback = codeFormat
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
                local bufopts = {noremap = true, silent = true, buffer = bufnr}
                local function desc(d)
                    return vim.tbl_extend("force", bufopts, {desc = d})
                end

                vim.keymap.set('n', 'gd', function()
                    require("fzf-lua").lsp_definitions({
                        jump_to_single_result = true
                    })
                end, desc("Go definitions"))
                vim.keymap.set('n', 'gD', "<cmd>FzfLua lsp_declarations<cr>",
                               desc("Go declarations"))
                vim.keymap.set('n', 'gy', "<cmd>FzfLua lsp_typedefs<cr>",
                               desc("Go t[y]pe definitions"))
                vim.keymap.set('n', 'gI', "<cmd>FzfLua lsp_implementations<cr>",
                               desc("Go implementations"))
                vim.keymap.set('n', 'gr', "<cmd>FzfLua lsp_references<cr>",
                               desc("Go references"))
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, desc("Hover"))
                vim.keymap.set({'n', 'i'}, '<C-k>', vim.lsp.buf.signature_help,
                               desc("Signature help"))
                vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename,
                               desc("Code rename"))
                vim.keymap.set('n', '<leader>ca',
                               "<cmd>FzfLua lsp_code_actions<cr>",
                               desc("Code action"))
                vim.keymap.set('n', '<leader>cf', codeFormat,
                               desc("Code format"))
                vim.keymap.set('v', '<leader>cf', codeFormat,
                               desc("Code format in range"))
            end

            local function setup(server)
                local server_config = servers[server] or {}
                local server_opts = vim.tbl_deep_extend("force", {
                    capabilities = vim.deepcopy(capabilities)
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
            local all_mslp_servers = vim.tbl_keys(require(
                                                      "mason-lspconfig.mappings.server").lspconfig_to_package)
            local ensure_installed = {}

            for server, server_opts in pairs(servers) do
                if server_opts then
                    server_opts = server_opts == true and {} or server_opts
                    -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
                    if server_opts.mason == false or
                        not vim.tbl_contains(all_mslp_servers, server) then
                        setup(server)
                    else
                        ensure_installed[#ensure_installed + 1] = server
                    end
                end
            end

            mlsp.setup({ensure_installed = ensure_installed})
            mlsp.setup_handlers({setup})

            local icons = {
                Error = '󰅚 ', -- x000f015a
                Warn = '󰀪 ', -- x000f002a
                Info = '󰋽 ', -- x000f02fd
                Hint = '󰌶 ' -- x000f0336
            }
            for name, icon in pairs(icons) do
                name = "DiagnosticSign" .. name
                vim.fn.sign_define(name,
                                   {text = icon, texthl = name, numhl = ""})
            end
        end
    }, {
        "jose-elias-alvarez/null-ls.nvim",
        event = {"BufReadPre", "BufNewFile"},
        dependencies = {
            "nvim-lua/plenary.nvim", "williamboman/mason.nvim",
            "jay-babu/mason-null-ls.nvim"
        },
        opts = function()
            local null_ls = require("null-ls")
            return {
                sources = {
                    -- Anything not supported by mason.
                    null_ls.builtins.formatting.prettier
                }
            }
        end
    }, {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        config = function() require("mason").setup() end
    }, {
        "jay-babu/mason-null-ls.nvim",
        event = {"BufReadPre", "BufNewFile"},
        dependencies = {"williamboman/mason.nvim"},
        opts = {
            ensure_installed = {"lua_format"},
            automatic_installation = false,
            handlers = {}
        }
    }
}
