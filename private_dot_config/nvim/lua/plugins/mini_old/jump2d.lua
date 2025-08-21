require('mini.jump2d').setup({
  labels = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ',
  view = {
    dim = true,
    n_steps_ahead = 2,
  },
  mappings = {
    start_jumping = '<leader>j',
  },
})

local util = require('utils')

util.map({ 'n', 'x', 'o' }, '<leader>j', function()
  MiniJump2d.start(MiniJump2d.builtin_opts.single_character)
end, 'Start jumping')
