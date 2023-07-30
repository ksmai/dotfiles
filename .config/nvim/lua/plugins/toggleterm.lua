return {
    'akinsho/toggleterm.nvim',
    version = "*",
    keys = {
        {
            "<c-t>",
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
        open_mapping = [[<c-t>]],
        size = 20,
        hide_numbers = false,
        insert_mappings = true,
        terminal_mappings = true,
        persist_size = true,
        direction = "tab",
        shell = "/bin/fish",
        auto_scroll = true
    }
}
