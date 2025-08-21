require('mini.bracketed').setup({
  treesitter = { suffix = 's' },
})

local utils = require('utils')
local map, L = utils.map, utils.L

-- MiniBracketed/Buffer remap
--
map('n', 'L', function()
  MiniBracketed.buffer('forward')
end, 'Next buffer ->')
map('n', 'H', function()
  MiniBracketed.buffer('backward')
end, 'Previous buffer <-')
