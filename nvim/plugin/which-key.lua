local wk = require("which-key")
wk.setup({
    registers = true,
    window = {
        border = "single"
    },
})
wk.register {
    ['<leader>d'] = { name = '[D]ebug', _ = 'which_key_ignore' },
    ['<leader>r'] = { name = '[R]efactor', _ = 'which_key_ignore' },
    ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
    ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
    ['<leader>p'] = { name = '[P]eek', _ = 'which_key_ignore' },
    ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
    ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
    ['<leader>h'] = { name = 'Git [H]unk', _ = 'which_key_ignore' },
    ['<leader>q'] = { name = '[Q]uickfix', _ = 'which_key_ignore' },
    ['<leader>t'] = { name = '[T]oggle', _ = 'which_key_ignore' },
}
