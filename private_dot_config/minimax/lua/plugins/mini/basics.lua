require("mini.basics").setup({
	options = {
		basic = false,
		extra_ui = false,
		win_borders = "auto",
	},
	mappings = {
		basic = true,
		windows = true,
		move_with_alt = true,
	},
})
vim.o.winborder = "rounded"
