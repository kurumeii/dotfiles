local utils = require("config.utils")

-- Startup time
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		vim.g.start_time_finish = vim.uv.hrtime()
	end,
})

utils.set_ft("tmpl", "bash")

vim.api.nvim_create_autocmd("FileType", {
	pattern = "json,jsonc",
	callback = function()
		vim.bo.commentstring = "// %s"
	end,
})
