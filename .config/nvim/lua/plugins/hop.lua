return {
    'phaazon/hop.nvim',
    branch = 'v2',
    keys = {
        {
            "\\",
            function() require('hop').hint_char2({ multi_windows = true }) end,
            mode = "n",
            silent = true,
            noremap = true,
            desc = "Hop multi-windows"
        },
    },
    config = function()
        local hop = require('hop')
        hop.setup()
    end
}
