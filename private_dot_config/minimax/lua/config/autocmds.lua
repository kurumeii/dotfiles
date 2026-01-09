local utils = require("config.utils")

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

-- Startup time
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		vim.g.start_time_finish = vim.uv.hrtime()
	end,
})

utils.set_ft("tmpl", "bash")
