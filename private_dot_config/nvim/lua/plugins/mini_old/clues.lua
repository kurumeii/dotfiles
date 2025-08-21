local miniclue = require('mini.clue')
miniclue.setup({
  window = {
    config = {
      width = 'auto',
      anchor = 'SW',
      row = 'auto',
      col = 'auto',
      -- width = vim.api.nvim_list_uis()[1]['width'],
      border = 'double',
    },
  },
  triggers = {
    -- Leader triggers
    { mode = 'n', keys = '<Leader>' },
    { mode = 'x', keys = '<Leader>' },

    -- `g` key
    { mode = 'n', keys = 'g' },
    { mode = 'x', keys = 'g' },

    -- `[]` keys
    { mode = 'n', keys = '[' },
    { mode = 'n', keys = ']' },

    -- `\` key
    { mode = 'n', keys = [[\]] },

    -- Marks
    { mode = 'n', keys = "'" },
    { mode = 'n', keys = '`' },
    { mode = 'x', keys = "'" },
    { mode = 'x', keys = '`' },

    -- `z` key
    { mode = 'n', keys = 'z' },
    { mode = 'x', keys = 'z' },
    { mode = 'n', keys = '<C-w>' },
    -- Registers
    { mode = 'n', keys = '"' },
    { mode = 'x', keys = '"' },
    { mode = 'i', keys = '<C-r>' },
    { mode = 'c', keys = '<C-r>' },
  },

  clues = {
    -- Enhance this by adding descriptions for <Leader> mapping groups
    { mode = 'n', keys = '<leader>b', desc = 'Buffers ' },
    { mode = 'n', keys = '<leader>c', desc = 'Code ' },
    { mode = 'n', keys = '<leader>cs', desc = 'Spelling ' },
    { mode = 'n', keys = '<leader>g', desc = 'Git 󰊢' },
    { mode = 'n', keys = '<leader>f', desc = 'Find ' },
    { mode = 'n', keys = '<leader>t', desc = 'Terminal  ' },
    { mode = 'n', keys = '<leader>w', desc = 'Window ' },
    { mode = 'n', keys = '<leader>n', desc = 'Notify ' },
    { mode = 'n', keys = '<leader>l', desc = 'Lsp ' },
    { mode = 'n', keys = '<leader>d', desc = 'Debugger ' },
    { mode = 'n', keys = '<leader>s', desc = 'Sessions ' },
    { mode = 'n', keys = '<leader>u', desc = 'Ui ' },
    { mode = 'n', keys = '<leader>p', desc = 'Profile ' },
    { mode = 'n', keys = '<leader>x', desc = 'Extras ' },
    { mode = 'n', keys = '<leader>xa', desc = 'AI' },
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows({
      submode_move = true,
      submode_navigate = true,
      submode_resize = true,
    }),
    miniclue.gen_clues.z(),
  },
})
