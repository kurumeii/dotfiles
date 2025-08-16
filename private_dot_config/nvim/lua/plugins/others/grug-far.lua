local grug = require('grug-far')

grug.setup({
  headerMaxWidth = 80,
  transient = true,
})

local utils = require('utils')

utils.map({ 'n', 'v' }, utils.L('fg'), function()
  local ext = vim.bo.buftype == '' and vim.fn.expand('%:e')
  grug.open({
    prefills = {
      filesFilter = ext and ext ~= '' and '*.' .. ext or nil,
    },
  })
end, 'Find and grug')
