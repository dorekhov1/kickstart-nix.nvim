local telescope = require('telescope')
local actions = require('telescope.actions')

local builtin = require('telescope.builtin')

local layout_config = {
  vertical = {
    width = function(_, max_columns)
      return math.floor(max_columns * 0.99)
    end,
    height = function(_, _, max_lines)
      return math.floor(max_lines * 0.99)
    end,
    prompt_position = 'bottom',
    preview_cutoff = 0,
  },
}

-- Fall back to find_files if not in a git repo
local project_files = function()
  local opts = {} -- define here if you want to define something
  local ok = pcall(builtin.git_files, opts)
  if not ok then
    builtin.find_files(opts)
  end
end

---@param picker function the telescope picker to use
local function grep_current_file_type(picker)
  local current_file_ext = vim.fn.expand('%:e')
  local additional_vimgrep_arguments = {}
  if current_file_ext ~= '' then
    additional_vimgrep_arguments = {
      '--type',
      current_file_ext,
    }
  end
  local conf = require('telescope.config').values
  picker {
    vimgrep_arguments = vim.tbl_flatten {
      conf.vimgrep_arguments,
      additional_vimgrep_arguments,
    },
  }
end

--- Grep the string under the cursor, filtering for the current file type
local function grep_string_current_file_type()
  grep_current_file_type(builtin.grep_string)
end

--- Live grep, filtering for the current file type
local function live_grep_current_file_type()
  grep_current_file_type(builtin.live_grep)
end

--- Like live_grep, but fuzzy (and slower)
local function fuzzy_grep(opts)
  opts = vim.tbl_extend('error', opts or {}, { search = '', prompt_title = 'Fuzzy grep' })
  builtin.grep_string(opts)
end

local function fuzzy_grep_current_file_type()
  grep_current_file_type(fuzzy_grep)
end

vim.keymap.set('n', '<leader>sb', builtin.buffers, { desc = '[b]uffers' })
vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[f]iles' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[g]rep' })
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[h]elp' })
vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = 'current [w]ord' })
vim.keymap.set('n', '<leader>so', builtin.oldfiles, { desc = 'recently [o]pened files' })
vim.keymap.set('n', '<leader>sz', fuzzy_grep, { desc = 'f[z]f grep' })
vim.keymap.set('n', '<leader>s<M-z>', fuzzy_grep_current_file_type, { desc = 'f[z]f grep current file type' })
vim.keymap.set('n', '<leader>s<M-g>', live_grep_current_file_type, { desc = '[g]rep current file type' })
vim.keymap.set('n', '<leader>s<M-w>', grep_string_current_file_type, { desc = 'current [w]ord current file type' })

vim.keymap.set('n', '<leader>sp', project_files, { desc = '[p]roject files' })

vim.keymap.set('n', '<leader>sq', builtin.quickfix, { desc = '[q]uickfix list' })
vim.keymap.set('n', '<leader>sl', builtin.loclist, { desc = '[l]oclist' })
vim.keymap.set('n', '<leader>sr', builtin.registers, { desc = '[r]egisters' })
vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[d]iagnostics' })
vim.keymap.set('n', '<leader>sR', builtin.resume, { desc = '[R]esume' })
vim.keymap.set('n', '<leader>st', builtin.builtin, { desc = 'select [t]elescope' })
vim.keymap.set('n', '<leader>s:', builtin.command_history, { desc = 'command history' })
vim.keymap.set(
  'n',
  '<leader>s/',
  builtin.current_buffer_fuzzy_find,
  { desc = '[/] fuzzy search in current buffer' }
)
vim.keymap.set('n', '<leader>ss', builtin.lsp_document_symbols, { desc = 'document [s]ymbols' })
vim.keymap.set(
  'n',
  '<leader>sS',
  builtin.lsp_dynamic_workspace_symbols,
  { desc = 'dynamic workspace [S]ymbols' }
)

vim.keymap.set('n', '<leader>sm', telescope.extensions.manix.manix, { desc = '[m]anix (nix documentation)' })
telescope.setup {
  defaults = {
    path_display = {
      'truncate',
    },
    layout_strategy = 'vertical',
    layout_config = layout_config,
    mappings = {
      i = {
        ['<C-q>'] = actions.send_to_qflist,
        ['<C-l>'] = actions.send_to_loclist,
        -- ['<esc>'] = actions.close,
        ['<C-s>'] = actions.cycle_previewers_next,
        ['<C-a>'] = actions.cycle_previewers_prev,
      },
      n = {
        q = actions.close,
      },
    },
    preview = {
      treesitter = true,
    },
    history = {
      path = vim.fn.stdpath('data') .. '/telescope_history.sqlite3',
      limit = 1000,
    },
    color_devicons = true,
    set_env = { ['COLORTERM'] = 'truecolor' },
    prompt_prefix = '   ',
    selection_caret = '  ',
    entry_prefix = '  ',
    initial_mode = 'insert',
    vimgrep_arguments = {
      'rg',
      '-L',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
    },
  },
  extensions = {
    fzy_native = {
      override_generic_sorter = false,
      override_file_sorter = true,
    },
  },
}

telescope.load_extension('fzy_native')
telescope.load_extension('manix')
-- telescope.load_extension('smart_history')
