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
