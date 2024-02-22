require("tmux").setup()

vim.keymap.set('n', '<C-h>', "<cmd>lua require('tmux').move_left()<cr>")
vim.keymap.set('n', '<C-j>', "<cmd>lua require('tmux').move_bottom()<cr>")
vim.keymap.set('n', '<C-k>', "<cmd>lua require('tmux').move_top()<cr>")
vim.keymap.set('n', '<C-l>', "<cmd>lua require('tmux').move_right()<cr>")

