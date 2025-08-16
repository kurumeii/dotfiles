local lint = require('lint')
local utils = require('utils')

-- Lazy
vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
  group = vim.api.nvim_create_augroup('lazy_load_lint', { clear = false }),
  callback = function()
    lint.linters_by_ft = {
      markdown = { 'markdownlint-cli2' },
      css = { 'stylelint' },
      scss = { 'stylelint' },
    }
    require('config.cspell')
    require('config.biome')
  end,
})

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
  group = vim.api.nvim_create_augroup('lint', { clear = true }),
  callback = utils.debounce(100, function()
    local names = lint._resolve_linter_by_ft(vim.bo.ft)
    -- create a copy w/o modified the original
    names = vim.deepcopy(names)
    -- Fallback
    if #names == 0 then
      vim.list_extend(names, lint.linters_by_ft['_'] or {})
    end
    if #names > 0 then
      lint.try_lint(names)
    end
  end),
})
