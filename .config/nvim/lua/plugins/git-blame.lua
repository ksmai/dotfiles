return {
    "f-person/git-blame.nvim",
    event = { "BufReadPost" },
    config = function()
        vim.g.gitblame_date_format = "%r"
        vim.g.gitblame_ignored_filetypes = { "gitcommit" }
    end,
}
