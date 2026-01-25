require("mini.deps").add("stevearc/conform.nvim")
vim.api.nvim_create_autocmd("BufRead", {
	callback = function()
		require("conform").setup({
			notify_on_error = true,
			default_format_opts = {
				timeout_ms = 1000,
				lsp_format = "fallback",
				stop_after_first = true,
			},
			format_after_save = function(buf)
				return {
					bufnr = buf,
					async = true,
				}
			end,
			formatters_by_ft = {
				markdown = { "markdownlint-cli2" },
				lua = { "stylua" },
				json = { "biome" },
				yaml = { "yamlfix" },
				javascript = { "biome", "prettierd" },
				typescript = { "biome", "prettierd" },
				typescriptreact = { "biome", "prettierd" },
				javascriptreact = { "biome", "prettierd" },
				css = { "biome", "prettierd" },
				scss = { "biome", "prettierd" },
				kdl = { "kdlfmt" },
				sh = { "shfmt" },
			},
			formatters = {
				biome = {
					require_cwd = true,
				},
				stylua = {},
				yamlfix = {},
				["markdown-toc"] = {
					condition = function(_, ctx)
						for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
							if line:find("<!%-%- toc %-%->") then
								return true
							end
							return false
						end
					end,
				},
				["markdownlint-cli2"] = {
					condition = function(_, ctx)
						local diag = vim.tbl_filter(function(d)
							return d.source == "markdownlint"
						end, vim.diagnostic.get(ctx.buf))
						return #diag > 0
					end,
				},
			},
		})
		local utils = require("config.utils")
		utils.map("n", utils.L("cf"), require("conform").format, "Format buffer (Conform)")
	end,
})
