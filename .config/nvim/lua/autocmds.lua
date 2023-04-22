local function augroup(name)
    return vim.api.nvim_create_augroup("ksmai_" .. name, { clear = true })
end

-- highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    group = augroup("highlight_yank"),
    callback = function()
        vim.highlight.on_yank({
            higroup = "IncSearch",
            timeout = 500,
        })
    end,
})
