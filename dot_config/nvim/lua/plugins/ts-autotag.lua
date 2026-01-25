require("mini.deps").add("windwp/nvim-ts-autotag")

vim.api.nvim_create_autocmd("InsertEnter", {
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
