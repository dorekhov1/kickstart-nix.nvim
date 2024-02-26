require("catppuccin").setup({
    transparent_background = true,
    integrations = {
        cmp = true,
        gitsigns = true,
        -- nvimtree = true,
        treesitter = true,
        -- notify = false,
        --mini = {
        --    enabled = true,
        --    indentscope_color = "",
        --},
    }
})

vim.cmd.colorscheme "catppuccin-mocha"

local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = "single"
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end
