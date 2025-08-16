local lang_patterns = {
  jsx = { 'javascript/javascript.json', 'javascript/react-es7.json' },
  tsx = { 'javascript/javascript.json', 'javascript/typescript.json', 'javascript/react-ts.json' },
}
mininvim.deps.setup({
  {
    source = 'rafamadriz/friendly-snippets',
    cb = function()
      vim.api.nvim_create_autocmd({ 'InsertEnter' }, {
        pattern = '*',
        callback = function()
          local snippets, config_path = require('mini.snippets'), vim.fn.stdpath('config')
          snippets.setup({
            snippets = {
              snippets.gen_loader.from_lang({
                lang_patterns = lang_patterns,
              }),
              snippets.gen_loader.from_file(config_path .. '/snippets/global.json'),
              snippets.start_lsp_server(),
            },
            mappings = {
              expand = '',
            },
            expand = {
              select = function(snip, ins)
                local select = snippets.default_select
                select(snip, ins)
              end,
            },
          })
        end,
      })
    end,
  },
})
