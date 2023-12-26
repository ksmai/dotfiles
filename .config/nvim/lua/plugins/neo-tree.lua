return {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
    branch = "v2.x",
    dependencies = {
        "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim"
    },
    opts = {
        -- https://github.com/nvim-neo-tree/neo-tree.nvim#configuration-for-nerd-fonts-v3-users
        default_component_configs = {
            icon = {folder_empty = "󰜌", folder_empty_open = "󰜌"},
            git_status = {symbols = {renamed = "󰁕", unstaged = "󰄱"}}
        },
        document_symbols = {
            kinds = {
                File = {icon = "󰈙", hl = "Tag"},
                Namespace = {icon = "󰌗", hl = "Include"},
                Package = {icon = "󰏖", hl = "Label"},
                Class = {icon = "󰌗", hl = "Include"},
                Property = {icon = "󰆧", hl = "@property"},
                Enum = {icon = "󰒻", hl = "@number"},
                Function = {icon = "󰊕", hl = "Function"},
                String = {icon = "󰀬", hl = "String"},
                Number = {icon = "󰎠", hl = "Number"},
                Array = {icon = "󰅪", hl = "Type"},
                Object = {icon = "󰅩", hl = "Type"},
                Key = {icon = "󰌋", hl = ""},
                Struct = {icon = "󰌗", hl = "Type"},
                Operator = {icon = "󰆕", hl = "Operator"},
                TypeParameter = {icon = "󰊄", hl = "Type"},
                StaticMethod = {icon = '󰠄 ', hl = 'Function'}
            }
        },
        filesystem = {
            filtered_items = {hide_dotfiles = false},
            follow_current_file = {enabled = true, leave_dirs_open = false}
        }
    },
    init = function() vim.g.neo_tree_remove_legacy_commands = 1 end
}
