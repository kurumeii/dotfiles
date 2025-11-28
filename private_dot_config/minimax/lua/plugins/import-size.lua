MiniDeps.add("stuckinsnow/import-size.nvim")
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	callback = function()
		require("import-size").setup()
	end,
})
