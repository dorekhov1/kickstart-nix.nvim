-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Paste by replace
vim.keymap.set('v', '<leader>p', '"_dP', { desc = "Replace with P" })

-- Copy to system clipboard
vim.keymap.set({ 'v', 'n' }, '<leader>y', '"+y', { desc = "Copy to system clipboard" })

-- Copy entire file
vim.keymap.set('n', '<leader>Y', 'gg"+yG', { desc = "Copy the entire file to system clipboard" })

-- Move selection around
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

-- Remove {} motions from the jumplist
vim.keymap.set('n', '}', function()
  local count = vim.v.count1
  vim.cmd('keepjumps norm! ' .. count .. '}')
end, { noremap = true })
vim.keymap.set('n', '{', function()
  local count = vim.v.count1
  vim.cmd('keepjumps norm! ' .. count .. '{')
end, { noremap = true })

-- vim: ts=2 sts=2 sw=2 et
