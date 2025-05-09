local snippets = require('mini.snippets')
snippets.setup({
  snippets = {
    snippets.gen_loader.from_lang(),
    snippets.start_lsp_server(),
  },
  expand = {
    select = function(snip, ins)
      local select = snippets.default_select
      select(snip, ins)
    end,
  },
})
