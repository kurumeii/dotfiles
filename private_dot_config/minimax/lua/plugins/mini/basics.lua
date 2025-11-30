require("mini.basics").setup({
	options = {
		basic = false,
		extra_ui = true,
		win_borders = "single",
	},
	mappings = {
		basic = true,
		windows = true,
		move_with_alt = true,
	},
})

vim.opt.listchars:append({
	extends = "󰳟",
	precedes = "󰳝",
})
