local utils = require("utils")
return {
	{
		-- Main LSP Configuration
		"neovim/nvim-lspconfig",
		dependencies = {
			"mason-org/mason.nvim",
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			"justinsgithub/wezterm-types",
			"b0o/SchemaStore.nvim",
			"saghen/blink.cmp",
		},
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {},
			})
			require("mason-tool-installer").setup({
				ensure_installed = {
					"tailwindcss",
					"vtsls",
					"lua_ls",
					"stylua",
					"cspell",
					"marksman",
					"markdownlint-cli2",
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
				},
			})
			---@type lsp.ClientCapabilities
			local capabilities = vim.tbl_extend(
				"force",
				vim.lsp.protocol.make_client_capabilities(),
				require("blink.cmp").get_lsp_capabilities({}, false),
				-- require('mini.completion').get_lsp_capabilities(),
				{
					textDocument = {
						completion = {
							completionItem = {
								snippetSupport = true,
							},
						},
						foldingRange = {
							dynamicRegistration = false,
							lineFoldingOnly = true,
						},
					},
					workspace = {
						fileOperations = {
							didRename = true,
							willRename = true,
						},
						didChangeWatchedFiles = {
							dynamicRegistration = true,
						},
					},
				}
			)

			mininvim.utils.lsp({
				capabilities = capabilities,
			})

			vim.diagnostic.config({
				severity_sort = true,
				float = { border = "rounded", source = "if_many" },
				underline = { severity = vim.diagnostic.severity.ERROR },
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = mininvim.icons.error,
						[vim.diagnostic.severity.WARN] = mininvim.icons.warn,
						[vim.diagnostic.severity.INFO] = mininvim.icons.info,
						[vim.diagnostic.severity.HINT] = mininvim.icons.hint,
					},
				},
				virtual_text = {
					source = "if_many",
					spacing = 2,
					format = function(diagnostic)
						local diagnostic_message = {
							[vim.diagnostic.severity.ERROR] = diagnostic.message,
							[vim.diagnostic.severity.WARN] = diagnostic.message,
							[vim.diagnostic.severity.INFO] = diagnostic.message,
							[vim.diagnostic.severity.HINT] = diagnostic.message,
						}
						return diagnostic_message[diagnostic.severity]
					end,
				},
			})
			utils.map("n", utils.L("ca"), vim.lsp.buf.code_action, "Code action")
			utils.map("n", utils.L("cd"), vim.diagnostic.open_float, "Code show diagnostic")
		end,
	},
}
-- vim: ts=2 sts=2 sw=2 et
