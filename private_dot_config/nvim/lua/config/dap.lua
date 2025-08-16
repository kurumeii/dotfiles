local js = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' }
local adapters = { 'node', 'pwa-node', 'pwa-msedge', 'node-terminal' }
local dap = require('dap')
local vscode = require('dap.ext.vscode')
local json = require('plenary.json')

vscode.json_decode = function(str)
  return vim.json.decode(json.json_strip_comments(str))
end

for _, adapter in ipairs(adapters) do
  dap.adapters[adapter] = {
    type = 'server',
    host = 'localhost',
    port = '${port}',
    executable = {
      command = vim.fn.stdpath('data') .. '/mason/packages/js-debug-adapter/js-debug-adapter.cmd',
      args = {
        '${port}',
      },
    },
  }
end
for _, lang in ipairs(js) do
  dap.configurations[lang] = {
    {
      type = 'pwa-node',
      request = 'launch',
      name = 'Launch file',
      program = '${file}',
      cwd = vim.fn.getcwd(),
    },
    {
      name = 'Attach to node process',
      type = 'pwa-node',
      request = 'attach',
      rootPath = '${workspaceFolder}',
      processId = require('dap.utils').pick_process,
    },
    {
      type = 'pwa-msedge',
      request = 'launch',
      name = 'Start Edge with "localhost"',
      url = 'http://localhost:3000',
      webRoot = vim.fn.getcwd(),
      userDataDir = '${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir',
    },
  }
end
