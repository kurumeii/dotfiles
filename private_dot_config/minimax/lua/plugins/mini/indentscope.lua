local MiniIndentScope = require("mini.indentscope")
MiniIndentScope.setup({
	options = { try_as_border = true },
	draw = {
		animation = MiniIndentScope.gen_animation.quadratic({
			easing = "in-out",
			duration = 200,
			unit = "total",
		}),
	},
})

-- MiniIndentScope
vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"Trouble",
		"alpha",
		"dashboard",
		"fzf",
		"help",
		"lazy",
		"mason",
		"neo-tree",
		"notify",
		"sidekick_terminal",
		"snacks_dashboard",
		"snacks_notif",
		"snacks_terminal",
		"snacks_win",
		"toggleterm",
		"trouble",
	},
	desc = "Disable indentscope in these filetypes",
	callback = function()
		vim.b.miniindentscope_disable = true
	end,
})
