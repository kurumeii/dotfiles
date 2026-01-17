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
	},
})
require("mason-lspconfig").setup({
	ensure_installed = {},
})
