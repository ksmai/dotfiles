return {
    'folke/trouble.nvim',
    keys = {
        {
            "<leader>xx",
            "<cmd>TroubleToggle workspace_diagnostics<cr>",
            mode = "n",
            silent = true,
            noremap = true,
            desc = "Toggle trouble",
        },
    },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        require('trouble').setup({})
    end,
}
