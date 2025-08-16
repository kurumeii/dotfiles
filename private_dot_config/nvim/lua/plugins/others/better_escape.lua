require('better_escape').setup({
  default_mappings = false, -- setting this to false removes all the default mappings
  mappings = {
    -- i for insert
    i = {
      j = {
        j = false,
        k = '<Esc>',
      },
    },
    t = {
      q = {
        k = '<C-\\><C-n>',
      },
    },
    v = {
      j = {},
    },
    -- s = {
    --   j = {
    --     k = '<Esc>',
    --   },
    -- },
  },
})
