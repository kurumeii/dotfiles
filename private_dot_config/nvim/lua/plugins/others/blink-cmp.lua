local icons = require('mini.icons')
require('blink.cmp').setup({
  keymap = {
    preset = 'super-tab',
  },
  completion = {
    documentation = {
      auto_show = false,
    },
    menu = {
      draw = {
        treesitter = { 'lsp' },
        components = {
          kind_icon = {
            text = function(ctx)
              local kind_icon, _, _ = icons.get('lsp', ctx.kind)
              return kind_icon
            end,
            highlight = function(ctx)
              local _, hl, _ = icons.get('lsp', ctx.kind)
              return hl
            end,
          },
          kind = {
            highlight = function(ctx)
              local _, hl, _ = icons.get('lsp', ctx.kind)
              return hl
            end,
          },
        },
      },
    },
  },
  signature = {
    enabled = true,
    window = {
      show_documentation = false,
    },
  },
  appearance = {
    use_nvim_cmp_as_default = true,
    nerd_font_variant = 'mono',
  },
  snippets = {
    preset = 'mini_snippets',
  },
})
