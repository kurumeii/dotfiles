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
  { source = 'plugins.core' },
  { source = 'plugins.mini' },
  { source = 'plugins.theme' },
  { source = 'plugins.autocomplete' },
  { source = 'plugins.misc' },
  { source = 'plugins.ui' },
  {
    source = 'folke/snacks.nvim',
    later = true,
    cb = function()
      require('plugins.snacks')
    end,
  },
  { source = 'config.ftypes', later = true },
  -- {
  --   source = 'yetone/avante.nvim',
  --   name = 'avante',
  --   disable = false,
  --   later = true,
  --   version = 'main',
  --   depends = {
  --     'nvim-lua/plenary.nvim',
  --     'MunifTanjim/nui.nvim',
  --   },
  --   hooks = {
  --     post_checkout = require('utils').build_avante,
  --     post_install = require('utils').build_avante,
  --   },
  --   ---@module 'avante'
  --   ---@type avante.Config
  --   opts = {
  --     provider = 'gemini',
  --   },
  -- },
  -- {
  --   source = 'HakonHarnes/img-clip.nvim',
  --   name = 'img-clip',
  --   later = true,
  --   disable = true,
  --   opts = {
  --     default = {
  --       embed_image_as_base64 = false,
  --       prompt_for_file_name = false,
  --       drag_and_drop = {
  --         insert_mode = true,
  --       },
  --       -- required for Windows users
  --       use_absolute_path = true,
  --     },
  --   },
  -- },
})
