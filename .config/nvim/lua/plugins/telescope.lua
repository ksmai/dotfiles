return {
    "nvim-telescope/telescope.nvim",
    branch = '0.1.x',
    dependencies = {
        "nvim-lua/plenary.nvim",
        {"nvim-telescope/telescope-fzf-native.nvim", build = "make"}
    },
    opts = function()
        local actions = require("telescope.actions")
        return {
            defaults = {
                mappings = {i = {["<esc>"] = actions.close}},
                vimgrep_arguments = {
                    "rg", "--smart-case", "--no-heading", "--vimgrep",
                    "--hidden", "--iglob", "!.git/"
                },
                cache_picker = {num_pickers = 5}
            }
        }
    end,
    config = function(_, opts)
        local telescope = require("telescope")
        telescope.setup(opts)
        telescope.load_extension("fzf")
    end
}
