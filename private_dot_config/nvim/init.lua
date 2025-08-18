_G.mininvim = {
  icons = require('config.icons'),
  tw_colors = require('config.tailwind-color'),
  word_colors = require('config.color-word'),
  deps = require('config.mini'),
}

mininvim.deps.setup({
  { source = 'option' },
  { source = 'keymap' },
  { source = 'autocmd' },
  { source = 'ftypes', later = true },
  { source = 'plugins.core' },
  { source = 'plugins.mini' },
  { source = 'plugins.snacks' },
  { source = 'plugins.theme' },
  { source = 'plugins.autocomplete' },
  { source = 'plugins.misc' },
  { source = 'plugins.ui' },
})
