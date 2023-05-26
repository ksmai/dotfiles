return {
    {
        "L3MON4D3/LuaSnip",
        build = (not jit.os:find("Windows")) and
            "echo -e 'NOTE: jsregexp is optional, so not a big deal if it fails to build\n'; make install_jsregexp" or
            nil,
        dependencies = {
            "rafamadriz/friendly-snippets",
            config = function()
                require("luasnip.loaders.from_vscode").lazy_load()
            end
        },
        opts = {history = true, delete_check_events = "TextChanged"}
    }, {
        "hrsh7th/nvim-cmp",
        version = false, -- last release is way too old
        -- event = "InsertEnter",
        dependencies = {
            "L3MON4D3/LuaSnip", {"hrsh7th/cmp-nvim-lsp"},
            {"hrsh7th/cmp-buffer"}, {"hrsh7th/cmp-path"},
            {"saadparwaiz1/cmp_luasnip"}, "zbirenbaum/copilot-cmp",
            "ray-x/lsp_signature.nvim", {"onsails/lspkind.nvim"}
        },
        opts = function()
            local has_words_before = function()
                unpack = unpack or table.unpack
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and
                           vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(
                               col, col):match("%s") == nil
            end

            local cmp = require("cmp")
            local luasnip = require("luasnip")
            local lspkind = require('lspkind')

            local border_opts = {
                border = "single",
                winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None"
            }

            return {
                completion = {completeopt = "menu,menuone,noinsert"},
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end
                },
                window = {
                    completion = cmp.config.window.bordered(border_opts),
                    documentation = cmp.config.window.bordered(border_opts)
                },
                mapping = cmp.mapping.preset.insert({
                    -- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#super-tab-like-mapping
                    ["<C-n>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item({
                                behavior = cmp.SelectBehavior.Insert
                            })
                        elseif has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end, {"i", "s"}),
                    ["<C-p>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item({
                                behavior = cmp.SelectBehavior.Insert
                            })
                        elseif has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end, {"i", "s"}),
                    ["<C-b>"] = cmp.mapping.scroll_docs(-8),
                    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(8),
                    ["<C-d>"] = cmp.mapping.scroll_docs(4),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                            cmp.confirm({
                                behavior = cmp.ConfirmBehavior.Insert,
                                select = true
                            })
                        elseif luasnip.expand_or_locally_jumpable() then
                            -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
                            -- they way you will only jump inside the snippet region
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, {"i", "s"}),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        elseif cmp.visible() then
                            -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                            cmp.confirm({
                                behavior = cmp.ConfirmBehavior.Insert,
                                select = true
                            })
                        else
                            fallback()
                        end
                    end, {"i", "s"}),
                    ["<CR>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true
                    }) -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                }),
                sources = cmp.config.sources({
                    {name = "copilot", group_index = 2}, {name = "nvim_lsp"},
                    {name = "luasnip"}, {name = "buffer"}, {name = "path"}
                }),
                formatting = {
                    format = lspkind.cmp_format({
                        mode = "symbol_text",
                        menu = ({
                            buffer = "[Buffer]",
                            nvim_lsp = "[LSP]",
                            luasnip = "[Snippet]",
                            copilot = "[Copilot]",
                            path = "[Path]"
                        }),
                        symbol_map = {Copilot = ""},
                        maxwidth = 50,
                        ellipsis_char = '...'
                    })
                },
                experimental = {ghost_text = {hl_group = "LspCodeLens"}},
                sorting = {
                    priority_weight = 2,
                    comparators = {
                        require("copilot_cmp.comparators").prioritize,

                        -- Below is the default comparitor list and order for nvim-cmp
                        cmp.config.compare.offset,
                        -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
                        cmp.config.compare.exact, cmp.config.compare.score,
                        cmp.config.compare.recently_used,
                        cmp.config.compare.locality, cmp.config.compare.kind,
                        cmp.config.compare.sort_text, cmp.config.compare.length,
                        cmp.config.compare.order
                    }
                }
            }
        end,
        config = function(_, opts)
            local cmp = require("cmp")
            cmp.setup(opts)

            -- Set configuration for specific filetype.
            cmp.setup.filetype('gitcommit', {
                sources = cmp.config.sources({
                    {name = 'cmp_git'} -- You can specify the `cmp_git` source if you were installed it.
                }, {{name = 'buffer'}})
            })

            vim.api.nvim_set_hl(0, "CmpItemKindCopilot", {fg = "#6CC644"})
        end
    }, {
        "zbirenbaum/copilot-cmp",
        dependencies = {"zbirenbaum/copilot.lua"},
        opts = {}
    }, {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        build = ":Copilot auth",
        opts = {suggestion = {enabled = false}, panel = {enabled = false}}
    }, {"ray-x/lsp_signature.nvim", opts = {}}
}
