require('mini.completion').setup({
  delay = {
    completion = 300,
    info = 200,
    signature = 100,
  },
  window = {
    info = { height = 25, width = 80, border = 'rounded' },
    signature = { height = 25, width = 80, border = 'rounded' },
  },
  lsp_completion = {
    source_func = 'omnifunc',
    process_items = function(items, base)
      return require('mini.completion').default_process_items(items, base, {
        filtersort = 'fuzzy',
        kind_priority = {
          Text = -1,
          Snippet = 99,
        },
      })
    end,
  },
})
local utils = require('utils')

utils.map(
  { 'i' },
  '<cr>',
  function()
    if vim.fn.pumvisible() ~= 0 then
      local item_selected = vim.fn.complete_info()['selected'] ~= -1
      return item_selected and vim.keycode('<c-y>') or vim.keycode('<c-y><cr>')
    end
    return MiniPairs.cr()
  end,
  'Accept completion',
  {
    expr = true,
  }
)
