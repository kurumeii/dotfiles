require('mini.git').setup()

vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniGitCommandSplit',
  callback = function(au_data)
    if au_data.data.git_subcommand ~= 'blame' then
      return
    end

    -- Align blame output with source
    local win_src = au_data.data.win_source
    vim.wo.wrap = false
    vim.fn.winrestview({ topline = vim.fn.line('w0', win_src) })
    vim.api.nvim_win_set_cursor(0, { vim.fn.line('.', win_src), 0 })

    -- Bind both windows so that they scroll together
    vim.wo[win_src].scrollbind, vim.wo.scrollbind = true, true
  end,
})
vim.api.nvim_create_autocmd({ 'BufReadPost' }, {
  callback = function(arg)
    local utils = require('utils')
    utils.map({ 'n', 'x' }, utils.L('ga'), MiniGit.show_at_cursor, 'Show at cursor', {
      buffer = arg.buf,
    })
  end,
})
