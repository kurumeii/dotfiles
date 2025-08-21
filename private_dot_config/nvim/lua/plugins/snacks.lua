return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      bigfile = { enabled = true },
      -- dashboard = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      lazygit = { enabled = true },
      terminal = { enabled = true },
      image = { enabled = true },
      styles = {
        notification = {
          wo = { wrap = true },
        },
      },
    },
    keys = {
      {
        '<leader>ts',
        function()
          Snacks.terminal.toggle()
        end,
        desc = 'Toggle terminal split',
      },
      {
        '<leader>tf',
        function()
          Snacks.terminal.toggle(nil, {
            win = {
              style = 'float',
              border = 'rounded',
              width = 0.7,
            },
          })
        end,
        desc = 'Toggle terminal float',
      },
      {
        '<leader>gg',
        function()
          Snacks.lazygit.open()
        end,
        desc = 'Open lazygit',
      },
      {
        "<leader>nh",
        function()
          Snacks.notifier.show_history()
        end,
        desc = "Notification History"
      },
    },
  },
  {
    'folke/edgy.nvim',
    ---@module 'edgy'
    ---@param opts Edgy.Config
    opts = function(_, opts)
      for _, pos in ipairs({ 'top', 'bottom', 'left', 'right' }) do
        opts[pos] = opts[pos] or {}
        table.insert(opts[pos], {
          ft = 'snacks_terminal',
          size = { height = 0.4 },
          title = '%{b:snacks_terminal.id}: %{b:term_title}',
          filter = function(_buf, win)
            return vim.w[win].snacks_win
                and vim.w[win].snacks_win.position == pos
                and vim.w[win].snacks_win.relative == 'editor'
                and not vim.w[win].trouble_preview
          end,
        })
      end
    end,
  },
}
