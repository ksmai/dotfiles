return {
    "ibhagwan/fzf-lua",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        {"junegunn/fzf", build = "./install --bin"}
    },
    keys = {
        {
            "<C-p>",
            function() require("fzf-lua").files() end,
            mode = "n",
            noremap = true,
            silent = true,
            desc = "Find files"
        }, {
            "<leader>fg",
            function() require("fzf-lua").live_grep_native() end,
            mode = "n",
            noremap = true,
            silent = true,
            desc = "Live grep"
        }, {
            "<leader>fw",
            function() require("fzf-lua").grep_cword() end,
            mode = "n",
            noremap = true,
            silent = true,
            desc = "Find word under cursor"
        }, {
            "<leader>fW",
            function() require("fzf-lua").grep_cWORD() end,
            mode = "n",
            noremap = true,
            silent = true,
            desc = "Find WORD under cursor"
        }, {
            "<leader>fw",
            function() require("fzf-lua").grep_visual() end,
            mode = "v",
            noremap = true,
            silent = true,
            desc = "Find selected word"
        }, {
            "<leader>fc",
            function() require("fzf-lua").commands() end,
            mode = "n",
            noremap = true,
            silent = true,
            desc = "Find commands"
        }, {
            "<leader>fC",
            function() require("fzf-lua").command_history() end,
            mode = "n",
            noremap = true,
            silent = true,
            desc = "Find command history"
        }, {
            "<leader>fh",
            function() require("fzf-lua").help_tags() end,
            mode = "n",
            noremap = true,
            silent = true,
            desc = "Find help tags"
        }, {
            "<leader>fr",
            function() require("fzf-lua").resume() end,
            mode = "n",
            noremap = true,
            silent = true,
            desc = "Resume previous picker"
        }, {
            "<leader>fz",
            function() require("fzf-lua").blines() end,
            mode = "n",
            noremap = true,
            silent = true,
            desc = "Fuzzy search (current file)"
        }
    },
    config = function() require("fzf-lua").setup({"telescope"}) end
}
