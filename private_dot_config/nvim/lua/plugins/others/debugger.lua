local utils = require('utils')
local map, L = utils.map, utils.L
local dap = require('dap')
local dap_widget = require('dap.ui.widgets')
local dapui = require('dapui')

require('mason-nvim-dap').setup({
  ensure_installed = {},
  automatic_installation = false,
})

-- TODO: Config the icons
vim.fn.sign_define('DapBreakpoint', { text = '🟥', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '▶️', texthl = '', linehl = '', numhl = '' })
dapui.setup({
  icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
  controls = {
    icons = {
      pause = '⏸',
      play = '▶',
      step_into = '⏎',
      step_over = '⏭',
      step_out = '⏮',
      step_back = 'b',
      run_last = '▶▶',
      terminate = '⏹',
      disconnect = '⏏',
    },
  },
})

dap.listeners.after.event_initialized['dapui_config'] = dapui.open
dap.listeners.before.event_terminated['dapui_config'] = dapui.close
dap.listeners.before.event_exited['dapui_config'] = dapui.close

vim.api.nvim_set_hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })

require('config.dap')

-- REMAPS ====================================================================
map('n', L('dc'), dap.continue, 'Debug continue')
map('n', L('db'), dap.toggle_breakpoint, 'Debug breakpoint toggle')
map('n', L('dB'), function()
  dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
end, 'Debug breakpoint condition')
map('n', L('dg'), dap.goto_, 'Debug goto')
map('n', L('di'), dap.step_into, 'Debug step into')
map('n', L('do'), dap.step_out, 'Debug step out')
map('n', L('dO'), dap.step_over, 'Debug step over')
map('n', L('dp'), dap.pause, 'Debug pause')
map('n', L('dw'), dap_widget.hover, 'Debug widget hover')
map('n', L('du'), dapui.toggle, 'Debug UI toggle')
