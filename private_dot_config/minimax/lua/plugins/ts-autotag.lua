MiniDeps.add("windwp/nvim-ts-autotag")
vim.api.nvim_create_autocmd("InsertEnter", {
	pattern = { "typescript", "javascriptreact", "typescriptreact", "javascript" },
	callback = function()
		--FIXME: Legacy errors
		require("nvim-ts-autotag").setup({
			enable_close = true,
			enable_rename = true,
			enable_close_on_slash = false,
		})
	end,
})
