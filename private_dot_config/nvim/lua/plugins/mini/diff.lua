require('mini.diff').setup({
  view = {
    -- Visualization style. Possible values are 'sign' and 'number'.
    style = 'sign',
    signs = {
      add = '▎',
      change = '▎',
      delete = '',
    },
  },
  mappings = {
    -- Apply hunks inside a visual/operator region
    apply = 'gh',

    -- Reset hunks inside a visual/operator region
    reset = 'gH',

    -- Hunk range textobject to be used inside operator
    -- Works also in Visual mode if mapping differs from apply and reset
    textobject = 'gh',

    -- Go to hunk range in corresponding direction
    goto_first = '[H',
    goto_prev = '[h',
    goto_next = ']h',
    goto_last = ']H',
  },
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniDiffUpdated',
  callback = function(data)
    local summary = vim.b[data.buf].minidiff_summary
    local t = {}
    if summary == nil then
      return
    end
    if summary.add > 0 then
      table.insert(t, mininvim.icons.git_add .. ' ' .. summary.add)
    end
    if summary.change > 0 then
      table.insert(t, mininvim.icons.git_edit .. ' ' .. summary.change)
    end
    if summary.delete > 0 then
      table.insert(t, mininvim.icons.git_remove .. ' ' .. summary.delete)
    end
    vim.b[data.buf].minidiff_summary_string = table.concat(t, ' ')
  end,
})

vim.api.nvim_create_autocmd({ 'BufReadPost' }, {
  callback = function(arg)
    local utils = require('utils')
    utils.map('n', utils.L('ug'), MiniDiff.toggle_overlay, 'UI toggle git overlay', {
      buffer = arg.buf,
    })
    utils.map('n', utils.L('uG'), MiniDiff.toggle, 'UI toggle git', {
      buffer = arg.buf,
    })
  end,
})
