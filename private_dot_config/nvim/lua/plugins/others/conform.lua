local conform = require('conform')
local utils = require('utils')

-- Lazy load
vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
  group = vim.api.nvim_create_augroup('lazyLoad-mason', { clear = false }),
  callback = function(args)
    conform.setup({
      notify_on_error = true,
      default_format_opts = {
        timeout_ms = 1000,
        lsp_format = 'fallback',
        stop_after_first = true,
      },
      format_after_save = {
        bufnr = args.bufnr,
        async = true,
      },
      formatters_by_ft = {
        markdown = { 'markdownlint-cli2' },
        lua = { 'stylua' },
        json = { 'biome' },
        yaml = { 'yamlfix' },
        javascript = { 'biome', 'prettierd' },
        typescript = { 'biome', 'prettierd' },
        typescriptreact = { 'biome', 'prettierd' },
        javascriptreact = { 'biome', 'prettierd' },
        css = { 'biome', 'prettierd' },
        scss = { 'biome', 'prettierd' },
      },
      formatters = {
        biome = {
          require_cwd = true,
        },
        stylua = {},
        yamlfix = {},
        ['markdown-toc'] = {
          condition = function(_, ctx)
            for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
              if line:find('<!%-%- toc %-%->') then
                return true
              end
              return false
            end
          end,
        },
        ['markdownlint-cli2'] = {
          condition = function(_, ctx)
            local diag = vim.tbl_filter(function(d)
              return d.source == 'markdownlint'
            end, vim.diagnostic.get(ctx.buf))
            return #diag > 0
          end,
        },
      },
    })

    utils.map('n', utils.L('cf'), conform.format, 'Code format manually', {
      buffer = args.bufnr,
    })
    utils.map('n', utils.L('ca'), vim.lsp.buf.code_action, 'Code action', {
      buffer = args.bufnr,
    })
    utils.map('n', utils.L('cd'), vim.diagnostic.open_float, 'Code show diagnostic', {
      buffer = args.bufnr,
    })
  end,
})
