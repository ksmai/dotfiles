return {
    'akinsho/toggleterm.nvim',
    version = "*",
    keys = {
        {
            "<leader>t",
            "<cmd>ToggleTerm<cr>",
            mode = "n",
            noremap = true,
            silent = true,
            desc = "Toggle term"
        }, {
            "<leader>x",
            "<esc><cmd>ToggleTermSendVisualSelection<cr>",
            mode = "v",
            noremap = true,
            silent = true,
            desc = "Send selection to term"
        }
    },
    opts = {
        open_mapping = [[<leader>t]],
        size = 20,
        hide_numbers = false,
        start_in_insert = false,
        insert_mappings = false,
        terminal_mappings = false,
        persist_size = true,
        direction = "tab",
        shell = "/bin/fish",
        auto_scroll = true
    }
}
