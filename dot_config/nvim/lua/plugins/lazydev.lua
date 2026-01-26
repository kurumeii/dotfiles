local add = require("mini.deps").add

add("b0o/SchemaStore.nvim")
add("nvim-lua/plenary.nvim")
add("justinsgithub/wezterm-types")
add("folke/lazydev.nvim")

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "lua" },
	callback = function()
		require("lazydev").setup({
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				{ path = "snacks.nvim", words = { "Snacks" } },
				{ path = "lazy.nvim", words = { "LazyVim" } },
				{ path = "wezterm-types", words = { "wezterm" } },
			},
		})
	end,
})
