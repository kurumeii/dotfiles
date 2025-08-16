vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = { 'markdown', 'Avante' },
  callback = function()
    require('render-markdown').setup({
      file_types = { 'markdown', 'Avante' },
    })
  end,
})
