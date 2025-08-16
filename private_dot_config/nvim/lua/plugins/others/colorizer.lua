local colorizer = require('oklch-color-picker')

colorizer.setup({
  highlight = {
    enabled = true,
    virtual_text = ' ',
    style = 'foreground',
    italic = true,
		bold = true,
    -- set it to false when style aren't forground and background
    -- emphasis = false,
  },
})

local utils = require('utils')

utils.map('n', utils.L('cp'), colorizer.pick_under_cursor, 'Pick color under cursor')
