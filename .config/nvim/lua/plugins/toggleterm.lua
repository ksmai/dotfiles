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
        insert_mappings = true,
        terminal_mappings = true,
        persist_size = true,
        direction = "tab",
        shell = "/bin/fish",
        auto_scroll = true
    }
}
