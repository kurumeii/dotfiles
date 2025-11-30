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

now(function()
	require("config.options")
	require("config.keymaps")
	require("config.mininvim")
	require("config.autocmds")
	require("plugins.mini.basics")
	require("plugins.mini.keymap")
	require("plugins.mini.files")
	require("plugins.mini.icons")
	require("plugins.mini.sessions")
	require("plugins.mini.clues")
	require("plugins.mini.notify")
	require("plugins.mini.starter")
	require("plugins.colorschemes")
	require("plugins.treesitter")
	require("plugins.conform")
	require("plugins.snacks")
end)
later(function()
	add("nvim-lua/plenary.nvim")
	add("b0o/SchemaStore.nvim")
	add("justinsgithub/wezterm-types")
end)
later(function()
	require("mini.bufremove").setup()
	require("mini.trailspace").setup()
	require("mini.move").setup()
	require("mini.fuzzy").setup()
	require("plugins.mini.operators")
	require("mini.bracketed").setup({
		treesitter = { suffix = "s" },
	})
	require("mini.extra").setup()
	require("mini.git").setup()
	require("plugins.mini.diff")
	require("plugins.mini.ai")
	require("plugins.mini.jump")
	require("plugins.mini.sessions")
	require("plugins.mini.surround")
	require("plugins.mini.comment")
	require("plugins.mini.snippets")
	require("plugins.mini.animate")
	require("plugins.mini.completion")
	require("plugins.mini.cursorword")
	require("plugins.mini.pairs")
	require("plugins.mini.hipatterns")
	require("plugins.mini.indentscope")
	require("plugins.mini.misc")
	require("plugins.mini.picks")
	require("plugins.mini.tabline")
	require("plugins.mini.statusline")
	require("plugins.mini.visits")
	require("plugins.nvim-ufo")
	require("plugins.import-size")
	require("plugins.lazydev")
	require("plugins.ts-autotag")
	require("plugins.mason")
	require("plugins.chezmoi")
	-- require("plugins.lualine")
	require("plugins.nvim-lint")
	require("plugins.nvim-navic")
end)
