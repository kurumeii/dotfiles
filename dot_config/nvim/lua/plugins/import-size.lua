require("mini.deps").add("stuckinsnow/import-size.nvim")
local utils = require("config.utils")
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	callback = function()
		local import_size = require("import-size")
		import_size.setup()
		utils.map("n", utils.L("ci"), import_size.toggle, "[TS]: Toggle import size")
	end,
})
