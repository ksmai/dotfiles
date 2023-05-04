return {
    "f-person/git-blame.nvim",
    event = { "BufReadPost" },
    keys = {
        {
            "<leader>gB",
            "<cmd>GitBlameToggle<cr>",
            mode = "n",
            silent = true,
            noremap = true,
            desc = "Toggle virtual git blame"
        },
    },
    init = function()
        vim.g.gitblame_date_format = "%r"
        vim.g.gitblame_ignored_filetypes = { "gitcommit" }
        vim.g.gitblame_enabled = 0
    end,
}
