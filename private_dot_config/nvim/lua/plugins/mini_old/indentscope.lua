require('mini.indentscope').setup({
  -- symbol = '│',
  options = { try_as_border = true },
  draw = {
    animation = require('mini.indentscope').gen_animation.cubic({
      easing = 'in-out',
      duration = 50,
      unit = 'total',
    }),
  },
})

-- MiniIndentScope
vim.api.nvim_create_autocmd('FileType', {
  pattern = {
    'Trouble',
    'alpha',
    'dashboard',
    'fzf',
    'help',
    'lazy',
    'mason',
    'neo-tree',
    'notify',
    'snacks_dashboard',
    'snacks_notif',
    'snacks_terminal',
    'snacks_win',
    'toggleterm',
    'trouble',
  },
  desc = 'Disable indentscope in these filetypes',
  callback = function()
    vim.b.miniindentscope_disable = true
  end,
})

-- vim.api.nvim_create_autocmd('User', {
--   pattern = 'SnacksDashboardOpened',
--   callback = function(data)
--     vim.b[data.buf].miniindentscope_disable = true
--   end,
-- })
