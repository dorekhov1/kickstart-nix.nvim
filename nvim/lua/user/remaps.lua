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

-- Buffer keymaps
vim.keymap.set('n', '[b', vim.cmd.bprevious, { silent = true, desc = 'Go to previous buffer' })
vim.keymap.set('n', ']b', vim.cmd.bnext, { silent = true, desc = 'Go to next buffer' })
vim.keymap.set('n', '[B', vim.cmd.bfirst, { silent = true, desc = 'Go to first buffer' })
vim.keymap.set('n', ']B', vim.cmd.blast, { silent = true, desc = 'Go to last buffer' })

-- Paste by replace
vim.keymap.set('v', '<leader>p', '"_dP', { desc = "Replace with P" })

-- Yank from current position till end of current line
vim.keymap.set('n', 'Y', 'y$', { silent = true, desc = 'yank to end of line' })

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


-- Toggle the quickfix list (only opens if it is populated)
local function toggle_qf_list()
  local qf_exists = false
  for _, win in pairs(vim.fn.getwininfo() or {}) do
    if win['quickfix'] == 1 then
      qf_exists = true
    end
  end
  if qf_exists == true then
    vim.cmd.cclose()
    return
  end
  if not vim.tbl_isempty(vim.fn.getqflist()) then
    vim.cmd.copen()
  end
end

vim.keymap.set('n', '<C-c>', toggle_qf_list, { desc = 'Toggle quickfix list' })

local function try_fallback_notify(opts)
  local success, _ = pcall(opts.try)
  if success then
    return
  end
  success, _ = pcall(opts.fallback)
  if success then
    return
  end
  vim.notify(opts.notify, vim.log.levels.INFO)
end


-- Cycle the quickfix and location lists
local function cleft()
  try_fallback_notify {
    try = vim.cmd.cprev,
    fallback = vim.cmd.clast,
    notify = 'Quickfix list is empty!',
  }
end

local function cright()
  try_fallback_notify {
    try = vim.cmd.cnext,
    fallback = vim.cmd.cfirst,
    notify = 'Quickfix list is empty!',
  }
end

vim.keymap.set('n', '[c', cleft, { silent = true, desc = 'cycle quickfix left' })
vim.keymap.set('n', ']c', cright, { silent = true, desc = 'cycle quickfix right' })
vim.keymap.set('n', '[C', vim.cmd.cfirst, { silent = true, desc = 'first quickfix entry' })
vim.keymap.set('n', ']C', vim.cmd.clast, { silent = true, desc = 'last quickfix entry' })

local function lleft()
  try_fallback_notify {
    try = vim.cmd.lprev,
    fallback = vim.cmd.llast,
    notify = 'Location list is empty!',
  }
end

local function lright()
  try_fallback_notify {
    try = vim.cmd.lnext,
    fallback = vim.cmd.lfirst,
    notify = 'Location list is empty!',
  }
end

vim.keymap.set('n', '[l', lleft, { silent = true, desc = 'cycle loclist left' })
vim.keymap.set('n', ']l', lright, { silent = true, desc = 'cycle loclist right' })
vim.keymap.set('n', '[L', vim.cmd.lfirst, { silent = true, desc = 'first loclist entry' })
vim.keymap.set('n', ']L', vim.cmd.llast, { silent = true, desc = 'last loclist entry' })

-- Resize splits
local toIntegral = math.ceil
vim.keymap.set('n', '<leader>w+', function()
  local curWinWidth = vim.api.nvim_win_get_width(0)
  vim.api.nvim_win_set_width(0, toIntegral(curWinWidth * 3 / 2))
end, { silent = true, desc = 'inc window width' })
vim.keymap.set('n', '<leader>w-', function()
  local curWinWidth = vim.api.nvim_win_get_width(0)
  vim.api.nvim_win_set_width(0, toIntegral(curWinWidth * 2 / 3))
end, { silent = true, desc = 'dec window width' })
vim.keymap.set('n', '<leader>h+', function()
  local curWinHeight = vim.api.nvim_win_get_height(0)
  vim.api.nvim_win_set_height(0, toIntegral(curWinHeight * 3 / 2))
end, { silent = true, desc = 'inc window height' })
vim.keymap.set('n', '<leader>h-', function()
  local curWinHeight = vim.api.nvim_win_get_height(0)
  vim.api.nvim_win_set_height(0, toIntegral(curWinHeight * 2 / 3))
end, { silent = true, desc = 'dec window height' })


-- vim: ts=2 sts=2 sw=2 et
