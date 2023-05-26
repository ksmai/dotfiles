return {
    "simrat39/symbols-outline.nvim",
    keys = {
        {
            "<leader>fn",
            "<cmd>SymbolsOutline<cr>",
            mode = "n",
            noremap = true,
            silent = true,
            desc = "Toggle symbols outline"
        }
    },
    config = function()
        require("symbols-outline").setup({
            auto_close = true,
            width = 40,
            wrap = true
        })
    end
}
