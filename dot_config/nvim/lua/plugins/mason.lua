require("mini.deps").add({
	source = "mason-org/mason.nvim",
	depends = {
		"mason-org/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
})

require("mason").setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})
require("mason-tool-installer").setup({
	ensure_installed = {
		"tailwindcss",
		"vtsls",
		"lua_ls",
		"stylua",
		"cspell",
		"biome",
		"prettierd",
		"eslint-lsp",
		"css_variables",
		"cssls",
		"stylelint",
		"prismals",
		"powershell_es",
		"yamlfix",
		"jsonls",
		"yamlls",
		"taplo",
		"js-debug-adapter",
		"copilot",
		"kdlfmt",
		"fish_lsp",
		"shfmt",
	},
})
require("mason-lspconfig").setup({
	ensure_installed = {},
})
