require("mini.deps").add("neovim/nvim-lspconfig")
local utils = require("config.utils")
-- LspAttach
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = function(args)
		---@type lsp.ClientCapabilities
		local capabilities = vim.tbl_extend(
			"force",
			vim.lsp.protocol.make_client_capabilities(),
			vim.g.mini.completion and require("mini.completion").get_lsp_capabilities() or {},
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
		utils.map("n", utils.L("cr"), vim.lsp.buf.rename, "LSP: rename")
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client and client.name == "vtsls" then
			utils.map("n", utils.L("co"), utils.action("source.organizeImports"), "[TS] Organize imports")
			utils.map("n", utils.L("cv"), utils.command("typescript.selectTypeScriptVersion"), "[TS] Select ts version")
		end
		utils.map("n", "<s-k>", vim.lsp.buf.hover)
		utils.map("i", "<c-/", vim.lsp.buf.signature_help)
	end,
})

vim.api.nvim_create_autocmd({ "BufReadPre" }, {
	once = true,
	callback = function()
		vim.cmd([[MasonToolsInstallSync]])
	end,
})
