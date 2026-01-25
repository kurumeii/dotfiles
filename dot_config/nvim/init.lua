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

vim.g.mini = {
	tabline = true,
	animate = true,
	completion = false,
	picks = true,
	show_dotfiles = true,
	notify = true,
	indent = true,
	explorer = true,
}

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
	if vim.g.mini.notify then
		require("plugins.mini.notify")
	end
	if vim.g.mini.explorer then
		require("plugins.mini.files")
	end
	if vim.g.mini.animate then
		require("plugins.mini.animate")
	end
end)
now(function()
	require("plugins.snacks")
end)
now(function()
	require("plugins.treesitter")
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
	require("plugins.lazydev")
	-- Typescript
	require("plugins.ts-autotag")
end)
later(function()
	require("plugins.mason")
	require("plugins.lspconfig")
end)
later(function()
	-- Linters
	require("plugins.nvim-lint")
	-- Format
	require("plugins.conform")
	-- Debugging
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
	if vim.g.mini.completion then
		require("plugins.mini.completion")
	end
	require("plugins.mini.cursorword")
	require("plugins.mini.pairs")
	require("plugins.mini.hipatterns")
	require("plugins.mini.misc")
	if vim.g.mini.picks then
		require("plugins.mini.picks")
	end
	require("plugins.mini.visits")
end)
later(function()
	if vim.g.mini.indent then
		require("plugins.mini.indentscope")
	end
end)
later(function()
	-- UI
	if vim.g.mini.tabline then
		require("plugins.mini.tabline")
	else
		require("plugins.lualine")
	end
	require("plugins.mini.statusline")
	require("plugins.nvim-navic")
end)
later(function()
	-- Misc
	require("plugins.nvim-ufo")
	-- require("plugins.import-size")
	require("plugins.chezmoi")
	require("plugins.sidekick")
end)
later(function()
	if not vim.g.mini.completion then
		require("plugins.blink")
	end
end)
