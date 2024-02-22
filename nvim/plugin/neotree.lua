-- Unless you are still migrating, remove the deprecated commands from v1.x
vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])


-- Open file tree
vim.keymap.set('n', "<leader>F", ":Neotree float toggle<CR>", { desc = "Toggle file tree" })


require("neo-tree").setup({
    event_handlers = {
        {
            event = "neo_tree_buffer_enter",
            handler = function()
                vim.cmd [[
                      setlocal relativenumber
                ]]
            end,
        },
        {
            event = "file_opened",
            handler = function()
                require("neo-tree.command").execute({ action = "close" })
            end
        },
    },
    default_component_configs = {
        git_status = {
            symbols = {
                -- Change type
                added     = "✚",
                deleted   = "✖",
                modified  = "",
                renamed   = "󰁕",
                -- Status type
                untracked = "",
                ignored   = "",
                unstaged  = "󰄱",
                staged    = "",
                conflict  = "",
            }
        }
    },
    filesystem = {
        window = {
            mappings = {
                ["O"] = "system_open",
            },
        },
        commands = {
            system_open = function(state)
                local node = state.tree:get_node()
                local path = node:get_id()
                -- macOs: open file in default application in the background.
                vim.fn.jobstart({ "xdg-open", "-g", path }, { detach = true })
                -- Linux: open file in default application
                vim.fn.jobstart({ "xdg-open", path }, { detach = true })
            end,
        },
        filtered_items = {
            visible = false, -- when true, they will just be displayed differently than normal items
            hide_dotfiles = true,
            hide_gitignored = true,
            hide_hidden = true, -- only works on Windows for hidden files/directories
            hide_by_name = {
                ".DS_Store",
                -- "thumbs.db",
                --"node_modules",
            },
            hide_by_pattern = {
                --"*.meta",
                --"*/src/*/tsconfig.json",
            },
            always_show = { -- remains visible even if other settings would normally hide it
                --".gitignored",
                ".gitignore",
                ".env",
                ".env.example",
            },
            never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
                --".DS_Store",
                --"thumbs.db",
                "__pycache__",
                ".mypy_cache",
            },
            never_show_by_pattern = { -- uses glob style patterns
                --".null-ls_*",
            },
        },
    }
})
