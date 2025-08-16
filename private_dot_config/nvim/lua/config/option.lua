vim.o.updatetime = 200
vim.o.timeout = true
vim.o.timeoutlen = 250
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'
vim.o.shell = 'wsl.exe'
vim.o.relativenumber = true
vim.o.number = true
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.ignorecase = true
vim.o.breakindent = true
vim.o.inccommand = 'nosplit'
vim.o.foldlevel = 99 -- Necessary
vim.o.foldlevelstart = 99
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.cmdheight = 1
vim.o.laststatus = 3
vim.o.signcolumn = 'yes'
vim.o.completeopt = 'menuone,noselect,fuzzy'
-- vim.o.showcmd = true
-- vim.o.showcmdloc = 'statusline'
vim.o.wrap = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.cursorline = true
vim.o.confirm = true
vim.o.mouse = 'a'
vim.o.formatoptions = 'jcroqlnt' -- tcqj
vim.o.grepformat = '%f:%l:%c:%m'
vim.o.grepprg = 'rg --vimgrep'
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.o.scrolloff = 5
vim.o.swapfile = false
-- vim.o.backup = false
vim.diagnostic.config({
  severity_sort = true,
  float = { border = 'single', source = 'if_many' },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = mininvim.icons.error,
      [vim.diagnostic.severity.WARN] = mininvim.icons.warn,
      [vim.diagnostic.severity.INFO] = mininvim.icons.info,
      [vim.diagnostic.severity.HINT] = mininvim.icons.hint,
    },
  },
  virtual_text = {
    spacing = 4,
    format = function(diagnostic)
      local diagnostic_message = {
        [vim.diagnostic.severity.ERROR] = diagnostic.message,
        [vim.diagnostic.severity.WARN] = diagnostic.message,
        [vim.diagnostic.severity.INFO] = diagnostic.message,
        [vim.diagnostic.severity.HINT] = diagnostic.message,
      }
      return diagnostic_message[diagnostic.severity]
    end,
  },
})
