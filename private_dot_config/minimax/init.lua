vim.g.start_time = vim.uv.hrtime()
local path_package = vim.fn.stdpath("data") .. "/site"
local mini_path = path_package .. "/pack/deps/start/mini.nvim"

if not vim.uv.fs_stat(mini_path) then
	vim.cmd('echo "Installing `mini.nvim`" | redraw')
	local clone_cmd = {
		"git",
		"clone",
		"--filter=blob:none",
		"--branch",
		"stable",
		"https://github.com/nvim-mini/mini.nvim",
		mini_path,
	}
	vim.fn.system(clone_cmd)
	vim.cmd("packadd mini.nvim | helptags ALL")
	vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

require("mini.deps").setup({
	path = {
		package = path_package,
	},
})

local now, later = MiniDeps.now, MiniDeps.later
local add = MiniDeps.add
local utils = require("config.utils")
vim.g.mini_tabline = true
vim.g.snacks_notify = false
vim.g.snacks_indent = false
vim.g.snacks_explorer = false
vim.g.mini_animate = true
vim.g.mini_completion = false
vim.g.show_dotfiles = false

now(function()
	require("config.options")
	require("config.keymaps")
	require("config.mininvim")
	require("config.autocmds")
	require("plugins.mini.basics")
	require("plugins.mini.keymap")
	require("plugins.mini.icons")
	require("plugins.mini.sessions")
	require("plugins.mini.clues")
	require("plugins.mini.starter")
	require("plugins.colorschemes")
	if vim.g.snacks_notify == false then
		require("plugins.mini.notify")
	end
	if vim.g.snacks_explorer == false then
		require("plugins.mini.files")
	end
	if vim.g.mini_animate then
		require("plugins.mini.animate")
	end
end)
now(function()
	add("folke/snacks.nvim")
	require("plugins.snacks")
end)
now(function()
	add({
		source = "nvim-treesitter/nvim-treesitter",
		checkout = "main",
		hooks = {
			post_checkout = function()
				vim.cmd("TSUpdate")
			end,
		},
	})
	add({
		source = "nvim-treesitter/nvim-treesitter-textobjects",
		checkout = "main",
	})
	add({ source = "nvim-treesitter/nvim-treesitter-context" })
	require("plugins.treesitter")
	-- Typescript
	add("windwp/nvim-ts-autotag")
	require("plugins.ts-autotag")
end)
later(function()
	-- Mini.plugins that doesnt need config
	require("mini.bufremove").setup()
	require("mini.trailspace").setup()
	require("mini.move").setup()
	require("mini.fuzzy").setup()
	require("mini.bracketed").setup({
		treesitter = { suffix = "s" },
	})
	require("mini.extra").setup()
end)
later(function()
	-- Lua dev
	add("b0o/SchemaStore.nvim")
	add("nvim-lua/plenary.nvim")
	add("justinsgithub/wezterm-types")
	add("folke/lazydev.nvim")
	require("plugins.lazydev")
end)
later(function()
	add("neovim/nvim-lspconfig")
	add({
		source = "mason-org/mason.nvim",
		depends = {
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
	})
	require("plugins.mason")
	require("plugins.lspconfig")
end)
later(function()
	-- Linters
	add("mfussenegger/nvim-lint")
	require("plugins.nvim-lint")
end)
later(function()
	-- Format
	add("stevearc/conform.nvim")
	require("plugins.conform")
end)
later(function()
	-- Debugging
	add("mfussenegger/nvim-dap")
	add({
		source = "rcarriga/nvim-dap-ui",
		depends = { "nvim-neotest/nvim-nio" },
	})
	add("theHamsta/nvim-dap-virtual-text")
	add("jay-babu/mason-nvim-dap.nvim")
	require("plugins.dap")
end)
later(function()
	require("plugins.mini.operators")
	require("plugins.mini.git")
	require("plugins.mini.ai")
	require("plugins.mini.jump")
	require("plugins.mini.sessions")
	require("plugins.mini.surround")
	require("plugins.mini.comment")
	require("plugins.mini.snippets")
	if vim.g.mini_completion then
		require("plugins.mini.completion")
	end
	require("plugins.mini.cursorword")
	require("plugins.mini.pairs")
	require("plugins.mini.hipatterns")
	require("plugins.mini.misc")
	require("plugins.mini.picks")
	require("plugins.mini.visits")
end)
later(function()
	if vim.g.snacks_indent == false then
		require("plugins.mini.indentscope")
	end
end)
later(function()
	-- UI
	if vim.g.mini_tabline then
		require("plugins.mini.tabline")
	else
		require("plugins.lualine")
	end
	require("plugins.mini.statusline")
	require("plugins.nvim-navic")
end)
later(function()
	-- Misc
	add("lbrayner/vim-rzip")
	require("plugins.nvim-ufo")
	add("stuckinsnow/import-size.nvim")
	require("plugins.import-size")
	require("plugins.chezmoi")
	add({
		source = "github/copilot.vim",
		hooks = {
			post_checkout = function()
				vim.cmd([[Copilot setup]])
			end,
		},
	})
	add("folke/sidekick.nvim")
	require("plugins.copilot")
	-- add("folke/edgy.nvim")
	-- require("plugins.edgy")
end)
later(function()
	if vim.g.mini_completion == false then
		add({
			source = "saghen/blink.cmp",
			hooks = {
				post_checkout = utils.build_blink,
				post_install = utils.build_blink,
			},
			depends = {
				"folke/lazydev.nvim",
			},
		})
		require("plugins.blink")
	end
end)
