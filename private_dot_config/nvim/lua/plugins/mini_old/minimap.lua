local map = require('mini.map')

map.setup({
  integrations = {
    map.gen_integration.builtin_search(),
    map.gen_integration.diff(),
    map.gen_integration.diagnostic({
      error = 'DiagnosticFloatingError',
      warn = 'DiagnosticFloatingWarn',
      info = 'DiagnosticFloatingInfo',
      hint = 'DiagnosticFloatingHint',
    }),
  },
  symbols = {
    encode = map.gen_encode_symbols.dot('3x2'),
  },
  window = {
    width = 1,
  },
})

local utils = require('utils')

--- Experimental features
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
  callback = function()
    if vim.bo.ft == 'ministarter' then
      return
    else
      MiniMap.open()
    end
  end,
})

utils.map('n', utils.L('um'), MiniMap.toggle, 'UI Minimap Toggle')
utils.map('n', utils.L('us'), MiniMap.toggle_side, 'UI Minimap Toggle Side')
