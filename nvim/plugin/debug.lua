local dap = require 'dap'
local dapui = require 'dapui'

vim.keymap.set('n', '<leader>dc', dap.continue, { desc = '[C]ontinue' })
vim.keymap.set('n', '<leader>di', dap.step_into, { desc = 'Step [I]nto' })
vim.keymap.set('n', '<leader>do', dap.step_over, { desc = 'Step [O]ver' })
vim.keymap.set('n', '<leader>de', dap.step_out, { desc = 'Step Out/[E]xit' })
vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'Toggle Breakpoint' })
vim.keymap.set('n', '<leader>dB', function()
  dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
end, { desc = 'Set Conditional Breakpoint' })
vim.keymap.set('n', '<leader>dR', dap.repl.open, { desc = '[R]EPL Open' })
vim.keymap.set('n', '<leader>dl', dap.run_last, { desc = 'Run [L]ast' })
vim.keymap.set('n', '<leader>dr', dap.restart, { desc = '[R]estart' })
vim.keymap.set('n', '<leader>dD', dap.disconnect, { desc = '[D]isconnect' })
vim.keymap.set('n', '<leader>dq', dap.close, { desc = 'Stop/[Q]uit' })

vim.keymap.set('n', '<leader>dt', dapui.toggle, { desc = '[T]oggle debugger UI' })
vim.keymap.set({ 'n', 'v' }, '<Leader>dh', function()
  require('dap.ui.widgets').hover()
end, { desc = '[H]over' })
vim.keymap.set({ 'n', 'v' }, '<Leader>dp', function()
  require('dap.ui.widgets').preview()
end, { desc = '[P]review' })
vim.keymap.set('n', '<Leader>df', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.frames)
end, { desc = '[F]rames' })
vim.keymap.set('n', '<Leader>ds', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.scopes)
end, { desc = '[S]copes' })

-- Dap UI setup
-- For more information, see |:help nvim-dap-ui|
dapui.setup {
  -- Set icons to characters that are more likely to work in every terminal.
  --    Feel free to remove or use ones that you like more! :)
  --    Don't feel like these are good choices.
  icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
  controls = {
    icons = {
      pause = '⏸',
      play = '▶',
      step_into = '⏎',
      step_over = '⏭',
      step_out = '⏮',
      step_back = 'b',
      run_last = '▶▶',
      terminate = '⏹',
      disconnect = '⏏',
    },
  },
}

dap.listeners.after.event_initialized['dapui_config'] = dapui.open
dap.listeners.before.event_terminated['dapui_config'] = dapui.close
dap.listeners.before.event_exited['dapui_config'] = dapui.close

-- Install python specific config
-- require('dap-python').setup('~/.pyenv/shims/python')
