require('mini.surround').setup({
  mappings = {
    add = 'sa',
    delete = 'sd',
    find = '',
    find_left = '',
    highlight = '',
    replace = 'sr',
    update_n_lines = '',

    -- Add this only if you don't want to use extended mappings
    suffix_last = '',
    suffix_next = '',
  },
  search_method = 'cover_or_next',
})
