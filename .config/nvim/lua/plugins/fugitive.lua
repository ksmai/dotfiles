return {
    "tpope/vim-fugitive",
    dependencies = {{"tpope/vim-rhubarb"}},
    keys = {
        {
            "<C-s>",
            function()
                local wins = vim.api.nvim_list_wins()
                local cur = vim.api.nvim_get_current_win()
                for _, win in ipairs(wins) do
                    local success, status =
                        pcall(vim.api.nvim_win_get_var, win, 'fugitive_status')
                    if success then
                        if status ~= nil and status ~= "" then
                            vim.api.nvim_win_close(win, false)
                            if vim.api.nvim_win_is_valid(cur) then
                                vim.api.nvim_set_current_win(cur)
                            end
                            return
                        end
                    end
                end
                vim.cmd('tab Git')
            end,
            mode = "n",
            noremap = true,
            silent = true,
            desc = "Toggle git status"
        }, {
            "<leader>gs",
            "<cmd>tab Git<cr>",
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
