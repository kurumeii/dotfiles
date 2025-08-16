local ai = require('mini.ai')
ai.setup({
  n_lines = 500,
  custom_textobjects = {
    L = MiniExtra.gen_ai_spec.line(), -- Line
    -- Tweak function call to not detect dot in function name
    f = ai.gen_spec.function_call({ name_pattern = '[%w_]' }),
    -- Function definition (needs treesitter queries with these captures)
    F = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
    o = ai.gen_spec.treesitter({
      a = { '@block.outer', '@loop.outer', '@conditional.outer' },
      i = { '@block.inner', '@loop.inner', '@conditional.inner' },
    }),
    B = MiniExtra.gen_ai_spec.buffer(),
    D = MiniExtra.gen_ai_spec.diagnostic(),
    I = MiniExtra.gen_ai_spec.indent(),
    u = ai.gen_spec.function_call(), -- u for "Usage"
    U = ai.gen_spec.function_call({ name_pattern = '[%w_]' }),
    N = MiniExtra.gen_ai_spec.number(),
  },
})
