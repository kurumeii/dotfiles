return {
  {
    'echasnovski/mini.nvim',
    event = 'VeryLazy',
    config = function()
      -- local ai = require('mini.ai')
      local extra = require('mini.extra')
      require('mini.colors').setup()
      require('mini.keymap').setup()
      -- require('mini.trailspace').setup()
      require('mini.fuzzy').setup()
      extra.setup()
      require('mini.operators').setup()
      require('mini.move').setup()
      -- ai.setup({
      --   n_lines = 500,
      --   custom_textobjects = {
      --     L = require('mini.extra').gen_ai_spec.line(), -- Line
      --     -- Tweak function call to not detect dot in function name
      --     f = ai.gen_spec.function_call({ name_pattern = '[%w_]' }),
      --     -- Function definition (needs treesitter queries with these captures)
      --     F = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
      --     o = ai.gen_spec.treesitter({
      --       a = { '@block.outer', '@loop.outer', '@conditional.outer' },
      --       i = { '@block.inner', '@loop.inner', '@conditional.inner' },
      --     }),
      --     B = require('mini.extra').gen_ai_spec.buffer(),
      --     D = require('mini.extra').gen_ai_spec.diagnostic(),
      --     I = require('mini.extra').gen_ai_spec.indent(),
      --     u = ai.gen_spec.function_call(), -- u for "Usage"
      --     U = ai.gen_spec.function_call({ name_pattern = '[%w_]' }),
      --     N = require('mini.extra').gen_ai_spec.number(),
      --   },
      -- })
      -- require('plugins.mini.sessions')
      -- require('plugins.mini.notify'),
      -- require('plugins.mini.starter')
      -- require('plugins.mini.icons')
      -- require('plugins.mini.basics')
      -- require('plugins.mini.statusline')
      -- require('plugins.mini.animate')
      -- require('plugins.mini.bracketed')
      -- require('plugins.mini.surround')
      -- require('plugins.mini.jump')
      -- require('plugins.mini.pairs')
      -- require('plugins.mini.cursorword')
      -- require('plugins.mini.comment')
      -- require('plugins.mini.misc')
      -- require('plugins.mini.snippets')
      -- require('plugins.mini.jump2d')
      -- require('plugins.mini.tabline')
      -- require('plugins.mini.pick')
      -- require('plugins.mini.diff')
      -- require('plugins.mini.git')

      -- require('plugins.mini.ai')
      -- require('plugins.mini.indentscope')
      -- require('plugins.mini.hipatterns')
      -- require('plugins.mini.minimap')
      -- require('plugins.mini.files')
      -- require('plugins.mini.clues')
      -- require('plugins.mini.visited')
    end,
  },
}
