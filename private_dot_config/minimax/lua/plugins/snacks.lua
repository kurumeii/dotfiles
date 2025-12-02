MiniDeps.add("folke/snacks.nvim")
require("snacks").setup({
	statuscolumn = {
		enabled = true,
		folds = {
			git_hl = false,
			open = true,
		},
	},
	explorer = {
		enabled = true,
		replace_netrw = false,
	},
	lazygit = { enabled = true },
	terminal = { enabled = true },
	bigfile = { enabled = true },
	image = { enabled = true },
})

local utils = require("config.utils")
utils.map("n", utils.L("fe"), Snacks.explorer.open, "Find Explorer")
utils.map("n", utils.L("gg"), Snacks.lazygit.open, "Open Lazygit")
utils.map("n", utils.L("t"), function()
	Snacks.terminal.toggle()
end, "Terminal")
