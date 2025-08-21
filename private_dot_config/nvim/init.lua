local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

_G.mininvim = {
  icons = require('config.icons'),
  tw_colors = require('config.tailwind-color'),
  word_colors = require('config.color-word'),
}

require('option')
require('keymap')
require('autocmd')

require('lazy').setup({
  spec = {
    { import = 'plugins.snacks' },
    { import = 'plugins.mini' },
    { import = 'plugins.treesitter' },
    { import = 'plugins.theme' },
    { import = 'plugins.ui' },
    -- { import = 'plugins.autocomplete' },
    { import = 'plugins.misc' },
  },
  change_detection = {
    enabled = true,
    notify = true,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        'gzip',
        -- 'matchit',
        -- 'matchparen',
        -- 'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
}, {
  ui = {
    icons = {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

vim.cmd.colorscheme('gruvbox')
-- require('ftypes') -- This is now handled by lazy.nvim
