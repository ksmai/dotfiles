local function null_ls_providers(filetype)
    local registered = {}
    -- try to load null-ls
    local sources_avail, sources = pcall(require, "null-ls.sources")
    if sources_avail then
        -- get the available sources of a given filetype
        for _, source in ipairs(sources.get_available(filetype)) do
            -- get each source name
            for method in pairs(source.methods) do
                registered[method] = registered[method] or {}
                table.insert(registered[method], source.name)
            end
        end
    end
    -- return the found null-ls sources
    return registered
end

local function null_ls_sources(filetype, method)
    local methods_avail, methods = pcall(require, "null-ls.methods")
    return methods_avail and null_ls_providers(filetype)[methods.internal[method]] or {}
end

local function lsp_client_names()
    local buf_client_names = {}
    for _, client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
        if client.name == "null-ls" then
            local null_ls_sources = {}
            for _, type in ipairs { "FORMATTING", "DIAGNOSTICS" } do
                for _, source in ipairs(M.utils.null_ls_sources(vim.bo.filetype, type)) do
                    null_ls_sources[source] = true
                end
            end
            vim.list_extend(buf_client_names, vim.tbl_keys(null_ls_sources))
        else
            table.insert(buf_client_names, client.name)
        end
    end
    return table.concat(buf_client_names, ", ")
end

return {
    'nvim-lualine/lualine.nvim',
    dependencies = {
        'nvim-tree/nvim-web-devicons',
        "tpope/vim-fugitive",
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
            lualine_y = {
                function()
                    if #vim.lsp.get_active_clients({ bufnr = 0 }) == 0 then
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

                    return lsp_client_names()
                end,
            },
        }
    },
}
