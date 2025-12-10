vim.api.nvim_create_autocmd("InsertEnter", {
	-- pattern = { "typescript", "javascriptreact", "typescriptreact", "javascript" },
	callback = function()
		require("nvim-ts-autotag").setup({
			opts = {
				enable_close = true,
				enable_rename = true,
				enable_close_on_slash = false,
			},
		})
	end,
})
