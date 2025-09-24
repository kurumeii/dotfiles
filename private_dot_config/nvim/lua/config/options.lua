vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.show_dotfiles = true

vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = "a"
vim.o.showmode = false
-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true
vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.ignorecase = true
vim.o.breakindent = true
vim.o.inccommand = "nosplit"
vim.o.foldlevel = 99 -- Necessary
vim.o.foldlevelstart = 99
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.cmdheight = 0
vim.o.laststatus = 2
vim.o.signcolumn = "yes"
vim.o.completeopt = "menuone,noselect,fuzzy"
-- vim.o.showcmd = true
-- vim.o.showcmdloc = 'statusline'
vim.o.wrap = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.cursorline = true
vim.o.confirm = true
vim.o.formatoptions = "jcroqlnt" -- tcqj
vim.o.grepformat = "%f:%l:%c:%m"
vim.o.grepprg = "rg --vimgrep"
vim.o.scrolloff = 5
