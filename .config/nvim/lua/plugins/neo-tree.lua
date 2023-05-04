return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",     -- not strictly required, but recommended
        { "MunifTanjim/nui.nvim" },
    },
    keys = {
        { "<C-n>", "<cmd>Neotree toggle<cr>", mode = "n", noremap = true, silent = true, desc = "Toggle Neotree" },
    },
    opts = {
        filesystem = {
            filtered_items = {
                hide_dotfiles = false,
            },
        },
    },
    init = function()
        vim.g.neo_tree_remove_legacy_commands = 1
    end,
}
