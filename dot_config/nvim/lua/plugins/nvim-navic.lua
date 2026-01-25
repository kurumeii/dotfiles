MiniDeps.add({
	source = "SmiteshP/nvim-navic",
	depends = {
		"neovim/nvim-lspconfig",
	},
})
require("nvim-navic").setup({
	highlight = true,
	depth_limit = 4,
	lsp = {
		auto_attach = true,
	},
})
vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
vim.api.nvim_create_autocmd("BufEnter", {
	callback = function()
		if vim.api.nvim_buf_line_count(0) > 10000 then
			vim.b.navic_lazy_update_context = true
		end
	end,
})
