return {
    'akinsho/toggleterm.nvim',
    version = "*",
    keys = {
        {
            "<leader>tt",
            "<cmd>ToggleTerm<cr>",
            mode = "n",
            noremap = true,
            silent = true,
            desc = "Toggle term"
        }, {
            "<leader>tT",
            "<cmd>ToggleTermToggleAll<cr>",
            mode = "n",
            noremap = true,
            silent = true,
            desc = "Toggle all terms"
        }, {
            "<leader>tx",
            "<esc><cmd>ToggleTermSendVisualSelection<cr>",
            mode = "v",
            noremap = true,
            silent = true,
            desc = "Send selection to term"
        }
    },
    opts = {
        size = 8,
        hide_numbers = false,
        insert_mappings = false,
        terminal_mappings = false,
        persist_size = true,
        direction = "horizontal",
        shell = "/bin/fish",
        auto_scroll = true
    }
}
