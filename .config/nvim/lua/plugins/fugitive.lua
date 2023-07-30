return {
    "tpope/vim-fugitive",
    dependencies = {{"tpope/vim-rhubarb"}},
    keys = {
        {
            "<leader>gs",
            "<cmd>tabnew<cr><cmd>Git<cr><c-w>o",
            mode = "n",
            noremap = true,
            silent = true,
            desc = "Git status"
        }, {
            "<leader>gd",
            "<cmd>Gvdiffsplit !^<cr><C-w>R",
            mode = "n",
            noremap = true,
            silent = true,
            desc = "Git diff against parent"
        }, {
            "<leader>gl",
            "<cmd>0Gclog<cr>",
            mode = "n",
            noremap = true,
            silent = true,
            desc = "Git log"
        }, {
            "<leader>gl",
            ":Gclog<cr>",
            mode = "v",
            noremap = true,
            silent = true,
            desc = "Git log (selected lines)"
        }, {
            "<leader>gb",
            "<cmd>Git blame --date=relative<cr>",
            mode = "n",
            noremap = true,
            silent = true,
            desc = "Git blame"
        }, {
            "<leader>gp",
            "<cmd>Git log --patch -- %<cr>",
            mode = "n",
            noremap = true,
            silent = true,
            desc = "Git log with patch"
        }, {
            "<leader>gp",
            [[<esc><cmd>lua vim.cmd("Git log --patch -L" .. vim.api.nvim_buf_get_mark(0, "<")[1] .. "," .. vim.api.nvim_buf_get_mark(0, ">")[1] .. ":%")<cr>]],
            mode = "v",
            noremap = true,
            silent = true,
            desc = "Git log with patch"
        }, {
            "<leader>gh",
            "<cmd>GBrowse<cr>",
            mode = "n",
            noremap = true,
            silent = true,
            desc = "Open in Github"
        }, {
            "<leader>gh",
            ":GBrowse<cr>",
            mode = "v",
            noremap = true,
            silent = true,
            desc = "Open in Github (selected lines)"
        }
    }
}
