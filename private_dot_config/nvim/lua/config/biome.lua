local lint = require('lint')
local valid_config_file = {
  'biome.json',
  'biome.jsonc',
}

local function config_path()
  for idx, config_file in pairs(valid_config_file) do
    local path = vim.fn.getcwd() .. '/' .. config_file ---@type string
    if vim.uv.fs_stat(path) then
      return path
    elseif idx == #valid_config_file then
      return nil
    end
  end
end

if config_path() == nil then
  return nil
else
  lint.linters_by_ft = {
    javascriptreact = { 'biome' },
    typescriptreact = { 'biome' },
    typescript = { 'biome' },
    javascript = { 'biome' },
    json = { 'biome' },
    css = { 'biome' },
    scss = { 'biome' },
  }
  lint.linters.biome = function()
    local default = require('lint.linters.biomejs')
    return default
  end
end
