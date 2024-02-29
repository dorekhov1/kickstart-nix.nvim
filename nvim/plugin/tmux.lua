require("tmux").setup {
    copy_sync = {
        enable = false,
        sync_clipboard = false,
        sync_registers = true,
    },
    resize = {
        enable_default_keybindings = false,
    }
}

vim.keymap.set('n', '<C-h>', "<cmd>lua require('tmux').move_left()<cr>")
vim.keymap.set('n', '<C-j>', "<cmd>lua require('tmux').move_bottom()<cr>")
vim.keymap.set('n', '<C-k>', "<cmd>lua require('tmux').move_top()<cr>")
vim.keymap.set('n', '<C-l>', "<cmd>lua require('tmux').move_right()<cr>")
