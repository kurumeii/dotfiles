vim.g.use_blink = true
vim.g.use_supermaven = true

mininvim.deps.setup({
  {
    source = 'saghen/blink.cmp',
    later = true,
    disable = vim.g.use_blink == false,
    checkout = '1.*',
    -- hooks = {
    --   post_install = require('utils').build_blink,
    --   post_checkout = require('utils').build_blink,
    -- },
    cb = function()
      require('plugins.autocomplete.blink-cmp')
    end,
  },
  {
    source = 'plugins.autocomplete.mini-completion',
    later = true,
    disable = vim.g.use_blink == true,
  },
  {
    source = 'supermaven-inc/supermaven-nvim',
    later = true,
    disable = vim.g.use_supermaven == false,
    cb = function()
      require('plugins.autocomplete.supermaven')
    end,
  },
  {
    source = 'Exafunction/windsurf.nvim',
    later = true,
    disable = vim.g.use_supermaven == true,
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    cb = function()
      require('codeium').setup({
        sources = {
          default = { 'lsp', 'path', 'snippets', 'buffer', 'codeium' },
          providers = {
            codeium = { name = 'Codeium', module = 'codeium.blink', async = true },
          },
        },
      })
    end,
  },
})

local get_plugin_lsp_capabilities = vim.g.use_blink == true and require('blink.cmp').get_lsp_capabilities()
  or require('mini.completion').get_lsp_capabilities()

---@type lsp.ClientCapabilities
local capabilities = vim.tbl_extend('force', vim.lsp.protocol.make_client_capabilities(), get_plugin_lsp_capabilities, {
  textDocument = {
    completion = {
      completionItem = {
        snippetSupport = true,
      },
    },
    foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    },
  },
  workspace = {
    fileOperations = {
      didRename = true,
      willRename = true,
    },
    didChangeWatchedFiles = {
      dynamicRegistration = true,
    },
  },
})

vim.lsp.config('*', {
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    if client.server_capabilities.documentSymbolProvider then
      require('nvim-navic').attach(client, bufnr)
    end
  end,
})
