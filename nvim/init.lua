local cmd = vim.cmd
local fn = vim.fn
local opt = vim.o
local g = vim.g
local wo = vim.wo

g.mapleader = ' '
g.maplocalleader = ' '

opt.compatible = false

-- Enable true colour support
if fn.has('termguicolors') then
  opt.termguicolors = true
end

-- Search down into subfolders
opt.path = vim.o.path .. '**'

wo.number = true
wo.relativenumber = true

opt.cursorline = true
opt.lazyredraw = true
opt.showmatch = true -- Highlight matching parentheses, etc

-- Highlight search results during search only
opt.incsearch = true
opt.hlsearch = false

-- Case-insensitive searching UNLESS \C or capital in search
opt.ignorecase = true
opt.smartcase = true

-- Spellchecking
opt.spell = true
opt.spelllang = 'en,ru'

-- Replace tabs with spaces
opt.expandtab = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4

opt.smartindent = true
opt.colorcolumn = '99'

opt.foldenable = true
opt.history = 2000
opt.nrformats = 'bin,hex' -- 'octal'
opt.undofile = true
opt.splitright = true
opt.splitbelow = true
--opt.cmdheight = 0

opt.mouse = 'a'
opt.breakindent = true
opt.updatetime = 250
opt.timeoutlen = 300
opt.completeopt = 'menuone,noselect'
opt.scrolloff = 8

opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

-- Configure Neovim diagnostic messages

local function prefix_diagnostic(prefix, diagnostic)
  return string.format(prefix .. ' %s', diagnostic.message)
end

local sign = function(opts)
  fn.sign_define(opts.name, {
    texthl = opts.name,
    text = opts.text,
    numhl = '',
  })
end
-- Requires Nerd fonts
sign { name = 'DiagnosticSignError', text = '󰅚' }
sign { name = 'DiagnosticSignWarn', text = '⚠' }
sign { name = 'DiagnosticSignInfo', text = 'ⓘ' }
sign { name = 'DiagnosticSignHint', text = '󰌶' }

vim.diagnostic.config {
  virtual_text = {
    prefix = '',
    format = function(diagnostic)
      local severity = diagnostic.severity
      if severity == vim.diagnostic.severity.ERROR then
        return prefix_diagnostic('󰅚', diagnostic)
      end
      if severity == vim.diagnostic.severity.WARN then
        return prefix_diagnostic('⚠', diagnostic)
      end
      if severity == vim.diagnostic.severity.INFO then
        return prefix_diagnostic('ⓘ', diagnostic)
      end
      if severity == vim.diagnostic.severity.HINT then
        return prefix_diagnostic('󰌶', diagnostic)
      end
      return prefix_diagnostic('■', diagnostic)
    end,
  },
  signs = true,
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    style = 'minimal',
    border = 'rounded',
    source = 'always',
    header = '',
    prefix = '',
  },
}

g.editorconfig = true

vim.opt.colorcolumn = '100'

-- Native plugins
cmd.filetype('plugin', 'indent', 'on')
cmd.packadd('cfilter') -- Allows filtering the quickfix list with :cfdo

-- let sqlite.lua (which some plugins depend on) know where to find sqlite
vim.g.sqlite_clib_path = require('luv').os_getenv('LIBSQLITE')

require("user.remaps")

-- this should be at the end, because
-- it causes neovim to source ftplugins
-- on the packpath when passing a file to the nvim command
cmd.syntax('on')
cmd.syntax('enable')
