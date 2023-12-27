return {
    'stevearc/oil.nvim',
    lazy = false,
    opts = {
        default_file_explorer = true,
        view_options = {show_hidden = true},
        use_default_keymaps = false,
        keymaps = {["<CR>"] = "actions.select"}
    },
    keys = {
        {
            "<leader>n",
            function()
                if vim.bo.filetype == "oil" then return end

                vim.cmd("Oil")
            end,
            mode = "n",
            noremap = true,
            silent = true,
            desc = "Open Oil"
        }
    },
    dependencies = {"nvim-tree/nvim-web-devicons"}
}
