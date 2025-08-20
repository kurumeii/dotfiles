vim.g.use_lualine = true
vim.g.use_snacks = true
mininvim.deps.setup({
  {
    source = 'SmiteshP/nvim-navic',
    depends = {
      'neovim/nvim-lspconfig',
    },
    later = true,
    disabled = vim.g.use_lualine == true,
    cb = function()
      require('nvim-navic').setup({
        highlight = true,
        depth_limit = 4,
      })
      vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
    end,
  },
  {
    source = 'nvim-lualine/lualine.nvim',
    depends = {
      'SmiteshP/nvim-navic',
    },
    disable = vim.g.use_lualine == false,
    later = true,
    cb = function()
      require('plugins.ui.lualine')
    end,
  },
  {
    source = 'plugins.ui.statusline',
    later = true,
    disable = vim.g.use_lualine == true,
  },
  {
    source = 'kevinhwang91/nvim-ufo',
    depends = {
      'kevinhwang91/promise-async',
    },
    later = true,
    cb = function()
      require('plugins.ui.ufo')
    end,
  },
  {
    source = 'folke/noice.nvim',
    later = true,
    name = 'noice',
    depends = {
      'MunifTanjim/nui.nvim',
    },
    ---@module 'noice'
    ---@type NoiceConfig
    opts = {
      lsp = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        lsp_doc_border = true,
      },
      notify = {
        enabled = false, -- Use snacks for notifications
      },
    },
  },
  { source = 'plugins.mini.pick', later = true, disable = vim.g.use_snacks == false },
})

-- vim.ui.select = vim.g.use_snacks == true and Snacks.picker.pick or require('mini.pick').ui_select
vim.ui.input = vim.g.use_snacks == true and Snacks.input.input or vim.ui.input
vim.notify = vim.g.use_snacks == true and Snacks.notifier.notify or require('mini.notify').make_notify
