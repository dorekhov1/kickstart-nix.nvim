local api = vim.api
local keymap = vim.keymap

local function preview_location_callback(_, result)
  if result == nil or vim.tbl_isempty(result) then
    return nil
  end
  local buf, _ = vim.lsp.util.preview_location(result[1])
  if buf then
    local cur_buf = vim.api.nvim_get_current_buf()
    vim.bo[buf].filetype = vim.bo[cur_buf].filetype
  end
end

local function peek_definition()
  local params = vim.lsp.util.make_position_params()
  return vim.lsp.buf_request(0, 'textDocument/definition', params, preview_location_callback)
end

local function peek_type_definition()
  local params = vim.lsp.util.make_position_params()
  return vim.lsp.buf_request(0, 'textDocument/typeDefinition', params, preview_location_callback)
end

--- Don't create a comment string when hitting <Enter> on a comment line
vim.api.nvim_create_autocmd('BufEnter', {
  group = vim.api.nvim_create_augroup('DisableNewLineAutoCommentString', {}),
  callback = function()
    vim.opt.formatoptions = vim.opt.formatoptions - { 'c', 'r', 'o' }
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local bufnr = ev.buf
    local client = vim.lsp.get_client_by_id(ev.data.client_id)

    -- Attach plugins
    -- require('nvim-navic').attach(client, bufnr)

    vim.cmd.setlocal('signcolumn=yes')
    vim.bo[bufnr].bufhidden = 'hide'

    -- Enable completion triggered by <c-x><c-o>
    vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
    local function desc(description)
      if description then
        description = 'LSP: ' .. description
      end

      return { noremap = true, silent = true, buffer = bufnr, desc = description }
    end

    keymap.set('n', 'gD', vim.lsp.buf.declaration, desc('[G]oto [D]eclaration'))
    keymap.set('n', 'gd', vim.lsp.buf.definition, desc('[G]oto [D]definition'))
    keymap.set('n', 'gt', vim.lsp.buf.type_definition, desc('[G]oto [T]ype definition'))
    keymap.set('n', 'gr', vim.lsp.buf.references, desc('[G]oto [R]eferences'))
    keymap.set('n', 'gi', vim.lsp.buf.implementation, desc('[G]oto [I]imlpementation'))

    keymap.set('n', '<leader>ph', vim.lsp.buf.hover, desc('[P]eek [H]over'))
    keymap.set('n', '<leader>ps', vim.lsp.buf.signature_help, desc('[P]eek [S]ignature'))
    keymap.set('n', '<leader>pd', peek_definition, desc('[P]eek [D]efinition'))
    keymap.set('n', '<leader>pt', peek_type_definition, desc('[P]eek [T]ype definition'))

    keymap.set('n', '<leader>rn', vim.lsp.buf.rename, desc('[R]efactor [N]ame'))

    keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, desc('[W]orkspace [A]dd Folder'))
    keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, desc('[W]orkspace [R]emove folder'))
    keymap.set('n', '<leader>wl', function()
      vim.print(vim.lsp.buf.list_workspace_folders())
    end, desc('[W]orkspace [L]ist Folders'))
    keymap.set('n', '<leader>ws', vim.lsp.buf.workspace_symbol, desc('[W]orkspace [S]ymbols'))

    keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, desc('[C]ode [A]action'))

    keymap.set('n', '<leader>cl', vim.lsp.codelens.run, desc('[C]ode [L]ens run'))
    keymap.set('n', '<leader>cL', vim.lsp.codelens.refresh, desc('[C]ode [L]ens refresh'))

    keymap.set('n', '<leader>f', function()
      vim.lsp.buf.format { async = true }
    end, desc('[lsp] format buffer'))
    keymap.set('n', '<leader>th', function()
      vim.lsp.inlay_hint(bufnr)
    end, desc('[T]oggle inlay [H]ints'))

    --keymap.set('n', '<leader>dd', vim.lsp.buf.document_symbol, desc('[lsp] document symbol'))

    -- Auto-refresh code lenses
    if not client then
      return
    end
    local function buf_refresh_codeLens()
      vim.schedule(function()
        if client.server_capabilities.codeLensProvider then
          vim.lsp.codelens.refresh()
          return
        end
      end)
    end
    local group = api.nvim_create_augroup(string.format('lsp-%s-%s', bufnr, client.id), {})
    if client.server_capabilities.codeLensProvider then
      vim.api.nvim_create_autocmd({ 'InsertLeave', 'BufWritePost', 'TextChanged' }, {
        group = group,
        callback = buf_refresh_codeLens,
        buffer = bufnr,
      })
      buf_refresh_codeLens()
    end
  end,
})

-- More examples, disabled by default

-- Toggle between relative/absolute line numbers
-- Show relative line numbers in the current buffer,
-- absolute line numbers in inactive buffers
-- local numbertoggle = api.nvim_create_augroup('numbertoggle', { clear = true })
-- api.nvim_create_autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave', 'CmdlineLeave', 'WinEnter' }, {
--   pattern = '*',
--   group = numbertoggle,
--   callback = function()
--     if vim.o.nu and vim.api.nvim_get_mode().mode ~= 'i' then
--       vim.opt.relativenumber = true
--     end
--   end,
-- })
-- api.nvim_create_autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter', 'CmdlineEnter', 'WinLeave' }, {
--   pattern = '*',
--   group = numbertoggle,
--   callback = function()
--     if vim.o.nu then
--       vim.opt.relativenumber = false
--       vim.cmd.redraw()
--     end
--   end,
-- })
